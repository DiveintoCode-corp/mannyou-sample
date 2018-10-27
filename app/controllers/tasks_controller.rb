class TasksController < ApplicationController
  before_action :require_logged_in
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :require_participant, only: [:show]
  before_action :require_author, only: [:edit, :update, :destroy]

  def index
    # 変数代入（わかりやすさを重視したindexアクションのコードになっているが、ややファットなので検索とか並び替えはメソッド化して他に移す方が良いかも）
    @tasks = current_user.tasks
    @expire_warning_tasks = @tasks.expire_warning.order(:expired_at).limit(50)
    @expire_danger_tasks = @tasks.expire_danger.order(:expired_at).limit(50)

    # 検索（絞り込み）
    if params[:task].present?
      @tasks = @tasks.title_search(params[:task][:title]) if params[:task][:title].present?
      @tasks = @tasks.status_search(params[:task][:status]) if params[:task][:status].present?
      # ラベル検索
      @tasks = @tasks.label_search(params[:task][:label_id].to_i) if label_search_require?
    end

    # 並び替え
    @tasks = @tasks.order(:expired_at) if sort_expired?
    @tasks = @tasks.order(priority: "DESC") if params[:sort_priority] == "true"

    # ページネーション
    @tasks = @tasks.includes(:user).page(params[:page]).per(20)
  end

  def show
    Read.create!(user_id: current_user.id, task_id: @task.id) unless Read.already?(current_user, @task)
  end

  def new
    @task = Task.new
  end

  def edit; end

  def create
    @task = current_user.tasks.build(task_params)

    # タスクと、そのラベリングを同時に保存し、なんらかの理由でラベリングに失敗したらタスクも保存しない
    if @task.valid?
      ActiveRecord::Base.transaction do
        @task.save!
        Labeling.tasks!(labeling_params[:label_ids], @task) if params[:task][:label_ids].present?
      end
      redirect_to @task, notice: t("layout.task.notice_create")
    else
      flash.now[:alert] = t("layout.task.not_create")
      render :new
    end
  rescue
    flash.now[:alert] = t("layout.task.not_labeling")
    render :new
  end

  def update
    if params[:task][:label_ids].present?
      ActiveRecord::Base.transaction do
        @task.update!(task_params)
        Labeling.peel_off!(@task.labeling_labels) # ラベルの取り外し
        Labeling.paste_tasks!(labeling_params[:label_ids], @task) # ラベルの取り付け
      end
      redirect_to tasks_path, notice: t("layout.task.notice_update")
    elsif params[:task][:label_ids].blank? && @task.update(task_params)
      redirect_to tasks_path, notice: t("layout.task.notice_update")
    else
      flash.now[:alert] = t("layout.task.not_update")
      render :edit
    end
  rescue
    flash.now[:alert] = t("layout.task.not_labeling")
    render :edit
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: t("layout.task.notice_destroy")
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def require_participant
    # 条件式長すぎて意味わかんないのでさっさとスコープ化する。あとincludes結合
    redirect_to tasks_path unless Task.possessed_groups_of(current_user).ids.include?(@task.id)
  end

  def require_author
    redirect_to tasks_path unless @task.user_id == current_user.id
  end

  def task_params
    params.require(:task).permit(:title, :content, :expired_at, :status, :read_at, files: [])
  end

  def labeling_params
    params.require(:task).permit(label_ids: [])
  end

  def sort_expired?
    params[:sort_expired] == "true" || (params[:task].present? && params[:task][:sort_expired] == "true")
  end

  def label_search_require?
    params[:task][:label_id].present? && !params[:task][:label_id].to_i.zero?
  end
end



# def escape_like(str)
#   # LIKE 句では % を \% に _ を \_ に \ を \\ にエスケープする必要がある
#   str.gsub(/\\/, "\\\\").gsub(/%/, "\\%").gsub(/_/, "\\_")
# end


# if params[:task].present?
#   # モデルに移すべき・・・かな？
#   @tasks.where("title LIKE ?", "%#{ params[:task][:title] }%") if params[:task][:title].present?
#   @tasks.where(status: "%#{ params[:task][:status] }%") if params[:task][:status].present?
#   # さらに変な文字が来た時用
#   # Task.where("title LIKE ?", "%#{ escape_like(params[:task][:title]) }%")
# end
