class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:update, :show]

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
