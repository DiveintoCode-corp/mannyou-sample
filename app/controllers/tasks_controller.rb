class TasksController < ApplicationController
  before_action :require_logged_in
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :require_participant, only: [:show]
  before_action :require_author, only: [:edit, :update, :destroy]

  def index
    # スコープ、書こう！

    # 変数代入
    @tasks = current_user.tasks.limit(50)
    @expire_warning_tasks = current_user.tasks.limit(50).where(status: [0, 1]).where(expired_at: Time.zone.today..(Time.zone.today + 7)).order(:expired_at)
    @expire_danger_tasks = current_user.tasks.limit(50).where(status: [0, 1]).where("expired_at < ?", Time.zone.today).order(:expired_at)

    # 検索（絞り込み。見本なのでそのまんまに書いているが、わかりづらい上にファットコントローラなのでモデルに移してリファクタすべき）
    if params[:task].present? && params[:task][:search] == "true"
      @tasks = @tasks.where("title LIKE ?", "%#{ params[:task][:title] }%") if params[:task][:title].present?
      @tasks = @tasks.where(status: params[:task][:status]) if params[:task][:status].present?
      # これがラベル検索。みづらい。
      unless params[:task][:label_id].blank? && params[:task][:label_id].to_i.zero?
        @tasks = @tasks.where(id: Labeling.where(label_id: params[:task][:label_id].to_i).pluck(:task_id))
      end
    end

    # 並び替え
    if sort_expired?
      @tasks = @tasks.order(:expired_at)
    elsif params[:sort_priority] == "true"
      @tasks = @tasks.order(priority: "DESC")
    end

    # ページネーション
    @tasks = @tasks.includes(:user).page(params[:page]).per(20)
  end

  def show
    Read.create!(user_id: current_user.id, task_id: @task.id) if Read.where(user_id: current_user.id).find_by(task_id: @task.id).blank?
  end

  def new
    @task = Task.new
  end

  def edit; end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      if params[:task][:label_ids].present?
        # エラー対策何もできていないので一応何かしたい
        labeling_params[:label_ids].each do |label_id|
          # paramsからラベル（厳密にはTaskとLabelの中間テーブル）を複数保存する
          Labeling.create!(task_id: @task.id, label_id: label_id.to_i) unless label_id.to_i == 0
        end
      end
      redirect_to @task, notice: t("layout.task.notice_create")
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      # ラベル関連どう考えても処理ロジックなのでモデルに移行する
      if params[:task][:label_ids].present?
        # ラベルの取り外し
        @task.labeling_labels.ids.each do |has_label_id|
          active_label = Labeling.where(task_id: @task.id).where(label_id: has_label_id).first
          # すでにそのTaskに保存されているものかつ、編集画面でチェックの外されているラベルがあったらそれの中間テーブルのレコードを削除する
          active_label.destroy! unless labeling_params[:label_ids].include?(has_label_id.to_s) || active_label.blank?
        end

        # ラベルの取り付け
        labeling_params[:label_ids].each do |label_id|
          Labeling.create!(task_id: @task.id, label_id: label_id.to_i) unless label_id.to_i == 0 || @task.labeling_labels.ids.include?(label_id.to_i)
        end
      end
      redirect_to tasks_path, notice: t("layout.task.notice_update")
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: t("layout.task.notice_destroy")
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def require_participant
    # 条件式長すぎて意味わかんないのでさっさとスコープ化する。あとincludes結合
    redirect_to tasks_path unless Task.where(user_id: current_user.join_groups.map{ |group| group.join_users }.flatten.pluck(:id)).ids.include?(@task.id)
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
end



# def escape_like(str)
#   # LIKE 句では % を \% に _ を \_ に \ を \\ にエスケープする必要がある
#   str.gsub(/\\/, "\\\\").gsub(/%/, "\\%").gsub(/_/, "\\_")
# end


# if params[:task].present? && params[:task][:search] == "true"
#   # モデルに移すべき・・・かな？
#   @tasks.where("title LIKE ?", "%#{ params[:task][:title] }%") if params[:task][:title].present?
#   @tasks.where(status: "%#{ params[:task][:status] }%") if params[:task][:status].present?
#   # さらに変な文字が来た時用
#   # Task.where("title LIKE ?", "%#{ escape_like(params[:task][:title]) }%")
# end
