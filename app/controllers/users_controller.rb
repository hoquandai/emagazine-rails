class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:update, :show]

  def create
    user = User.new(user_params)
    if user.save!
      # render_ok data: user
      render json: { message: 'OK', data: user }, status: 200
    else
      # render_error data: user, message: user.errors.full_message
      render json: { error: user.errors.full_message, data: {} }, status: 400
    end
  end

  def show; end

  def update
    if current_user.update_attributes(user_params)
      render :show
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end

  protected

  def user_params
    params.require(:user).permit(:name, :password, :email)
  end
end
