class JoinsController < ApplicationController
  before_action :set_join, only: [:destroy]
  before_action :require_logged_in
  before_action :require_not_author, only: [:destroy]

  def create
    @join = current_user.joins.build
    @join.group_id = params["group_id"]
    if @join.save
      redirect_to groups_path, notice: t("layout.join.notice_create")
    else
      redirect_to groups_path, notice: t("layout.join.notice_failer")
    end
  end

  def destroy
    @join.destroy
    redirect_to groups_path, notice: t("layout.join.notice_destroy")
  end

  private

  def set_join
    @join = Join.find(params[:id])
  end

  def require_not_author
    redirect_to groups_path if @join.group.user == current_user
  end
end
