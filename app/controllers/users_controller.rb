class UsersController < ApplicationController
  before_action :authenticate_user, only: [:update]

  def show
    user = User.find_by(id: params[:id])
    questions = user.questions
    votes = Vote.where(votable_type: 'Question', votable_id: questions.ids).size
    puts "=========", { user: user.as_json, questions: questions, stars: votes }
    render_ok(data: { user: user.as_json, questions: questions, stars: votes })
  end

  def update
    if current_user.update(user_params)
      render :show
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end

  def ranking
    users = User.top_ranking
    render_ok(data: users)
  end

  protected

  def user_params
    params.require(:user).permit(:name, :password, :email, :avatar)
  end
end
