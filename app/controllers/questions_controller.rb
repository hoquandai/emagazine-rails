class QuestionsController < ApplicationController
  before_action :authenticate_user, only: [:create]

  def create
    question = Question.new(question_params)

    if question.save
      render_ok(data: question)
    else
      render_error(message: question.errors.messages)
    end
  end

  def show
    question = Question.find_by(id: params[:id]).as_json
    if question
      render_ok(data: question)
    else
      render_error(message: 'Not Found', status: 404)
    end
  end

  def latest
    questions = Question.limit(4).order(created_at: :desc)
    render_ok(data: questions)
  end

  def trending_tags
    tags = ActsAsTaggableOn::Tag.most_used(10)
    if tags
      render_ok(data: tags)
    else
      render_error(message: 'Bad Request', status: 400)
    end
  end

  def hot
    questions = Question.hot.limit(6)
    if questions
      render_ok(data: questions)
    else
      render_error(message: 'Bad Request', status: 400)
    end
  end

  private

  def question_params
    params.require(:question).permit(:content, :category_id, :user_id, :tag_list)
  end
end
