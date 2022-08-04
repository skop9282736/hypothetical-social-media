class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]
  before_action :set_user, only: [:show, :destry]
  wrap_parameters :user, include: [:username, :email, :password, :password_confirmation]
  
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  def show
    render json: @user, status: :ok
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    unless @user.update(user_params)
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
  end

  private
  def user_params
    user_params = params.require(:user).permit(:username, :email, :password, :password_confirmation)
    user_params
  end

  def set_user
    @user = User.find(params[:id])
  end
  
end