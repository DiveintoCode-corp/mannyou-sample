class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    # 代入
    @tasks = Task.limit(50)

    # 検索（絞り込み）
    if params[:task].present? && params[:task][:search] == "true"
      @tasks = @tasks.where("title LIKE ?", "%#{ params[:task][:title] }%") if params[:task][:title].present?
      @tasks = @tasks.where(status: params[:task][:status]) if params[:task][:status].present?
    end

    # 並び替え
    if @tasks == sort_expired?
      @tasks = @tasks.order(:expired_at)
    elsif params[:sort_priority] == "true"
      @tasks = @tasks.order(priority: "DESC")
    end
  end

  def show; end

  def newq
    @task = Task.new
  end

  def edit; end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to @task, notice: t("layout.task.notice_create")
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: t("layout.task.notice_update")
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

  def task_params
    params.require(:task).permit(:title, :content, :expired_at, :status)
  end

  def sort_expired?
    params[:sort_expired] == "true" || (params[:task].present? && params[:task][:sort_expired] == "true")
  end

  def escape_like(str)
    # LIKE 句では % を \% に _ を \_ に \ を \\ にエスケープする必要がある
    str.gsub(/\\/, "\\\\").gsub(/%/, "\\%").gsub(/_/, "\\_")
  end
end




# if params[:task].present? && params[:task][:search] == "true"
#   # モデルに移すべき・・・かな？
#   @tasks.where("title LIKE ?", "%#{ params[:task][:title] }%") if params[:task][:title].present?
#   @tasks.where(status: "%#{ params[:task][:status] }%") if params[:task][:status].present?
#   # さらに変な文字が来た時用
#   # Task.where("title LIKE ?", "%#{ escape_like(params[:task][:title]) }%")
# end
