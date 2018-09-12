class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = params[:sort_created] == "true" ? Task.order(:expired_at) : Task.order(:title)
  end

  def show; end

  def new
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
    params.require(:task).permit(:title, :content, :expired_at)
  end
end
