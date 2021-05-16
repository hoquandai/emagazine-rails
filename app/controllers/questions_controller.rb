class QuestionsController < ApplicationController
  def create
    question = Question.new(question_params)

    if question.save
      render_ok(data: question)
    else
      render_error(message: question.messages)
    end
  end

  def show
    question = Question.find_by(id: params[:id])
    if question
      render_ok(data: question)
    else
      render_error(message: 'Not Found', status: 404)
    end
  end

  def latest
    questions = Question.order(created_at: :desc)
    render_ok(data: questions)
  end

  private

  def question_params
    params.require(:question).permit(:content, :category_id, :user_id)
  end
end
