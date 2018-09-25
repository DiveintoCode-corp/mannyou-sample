class LabelsController < ApplicationController
  before_action :require_logged_in
  before_action :set_label, only: [:edit, :update, :destroy]

  def index
    @labels = Label.where(user_id: current_user.id)
  end

  def new
    @label = Label.new
  end

  def create
    @label = current_user.labels.build(label_params)
    if @label.save
      redirect_to labels_path, notice: t("layout.label.notice_create")
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @label.update(label_params)
      redirect_to labels_path, notice: t("layout.label.notice_update")
    else
      render :edit
    end
  end

  def destroy
    @label.destroy
    redirect_to labels_path, notice: t("layout.label.notice_destroy")
  end

  private

  def set_label
    @label = Label.find(params[:id])
  end

  def label_params
    params.require(:label).permit(:name, :default)
  end
end
