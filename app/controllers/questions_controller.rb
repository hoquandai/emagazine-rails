class QuestionsController < ApplicationController
  before_action :authenticate_user, only: [:create, :destroy, :update]

  def index
    question = Question.all
    if question
      render_ok(data: question)
    else
      render_error(message: 'Failed to load questions')
    end
  end

  def create
    question = Question.new(question_params)

    if question.save
      render_ok(data: question)
    else
      render_error(message: question.errors.messages)
    end
  end

  def update
    question = Question.find_by(id: params[:id])
    if current_user == question.user && question.update(question_params)
      render_ok(data: question)
    else
      render_error(message: question.errors.message)
    end
  end

  def destroy
    question = Question.find_by(id: params[:id])
    if (current_user == question.user || current_user.is_admin) && question.destroy
      render_ok(data: question)
    else
      render_error(message: question.errors.message)
    end
  end

  def show
    authenticate_user if params[:authenticated]
    question = Question.find_by(id: params[:id])
    liked = Vote.exists?(voter_id: @current_user_id, votable: question)
    if question
      render_ok(data: question.as_json.merge(liked: liked, comments: question.comments))
    else
      render_error(message: 'Not Found', status: 404)
    end
  end

  def latest
    authenticate_user if params[:authenticated]
    questions = Question.limit(4).order(created_at: :desc)
    likes = Vote.where(voter_id: @current_user_id)
    data = { questions: questions, likes: likes.pluck(:votable_id) }
    render_ok(data: data)
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

  def interactive
    questions = Question.interactive.limit(5)
    if questions
      render_ok(data: questions)
    else
      render_error(message: 'Bad Request', status: 400)
    end
  end

  def top_tagging
    tag_names = ActsAsTaggableOn::Tag.most_used(1).map(&:name)
    questions = Question.tagged_with(tag_names).limit(4)
    if questions
      render_ok(data: questions)
    else
      render_error(message: 'Bad Request', status: 400)
    end
  end

  def category
    authenticate_user if params[:authenticated]
    questions = Question.where(category_id: params[:id])
    likes = Vote.where(voter_id: @current_user_id, votable_id: questions.ids)
    data = { questions: questions, likes: likes.pluck(:votable_id) }
    render_ok(data: data)
  end

  def tag
    authenticate_user if params[:authenticated]
    questions = Question.tagged_with(params[:tag])
    likes = Vote.where(voter_id: @current_user_id, votable_id: questions.ids)
    data = { questions: questions, likes: likes.pluck(:votable_id) }
    render_ok(data: data)
  end

  private

  def question_params
    params.require(:question).permit(:excerpt, :content, :category_id, :user_id, :tag_list, :image, :visible)
  end
end
