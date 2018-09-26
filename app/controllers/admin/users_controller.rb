class Admin::UsersController < ApplicationController
  before_action :require_admin
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.includes(:tasks)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_user_path(@user.id)
    else
      render 'admin/users/new' # ハードコーディングのため要相談
    end
  end

  def show
    @tasks = @user.tasks.limit(20)
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user.id)
    else
      render 'admin/users/edit' # ハードコーディングのため要相談
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_url
  end

  private

  def require_admin
    raise "unauthorized_administrator_access" unless current_user && current_user.admin == true
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end
end
