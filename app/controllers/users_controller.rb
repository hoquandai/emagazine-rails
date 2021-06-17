class UsersController < ApplicationController
  before_action :authenticate_user, only: [:update]

  def show
    user = User.find_by(id: params[:id])
    questions = user.questions
    votes = Vote.where(votable_type: 'Question', votable_id: questions.ids).size
    render_ok(data: { user: user.as_json, questions: questions, stars: votes })
  end

  def update
    target = User.find_by(id: user_params[:id])
    managable = current_user.is_admin || current_user == target
    puts target.inspect
    update_params = current_user.is_admin ? user_params : user_params.except(:is_admin)
    if managable && target.update(update_params)
      render :show
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end

  def ranking
    users = User.top_ranking
    render_ok(data: users)
  end

  def list
    users = User.all
    render_ok(data: users)
  end

  protected

  def user_params
    params.require(:user).permit(:id, :name, :password, :email, :avatar, :is_admin)
  end
end
