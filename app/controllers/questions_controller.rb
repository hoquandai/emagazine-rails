class QuestionsController < ApplicationController
  before_action :authenticate_user, only: [:create, :destroy, :update]

  def index
    question = Question.list.all
    if question
      render_ok(data: question)
    else
      render_error(message: 'Failed to load questions')
    end
  end

  def admin
    question = Question.unscoped.list.all
    if question
      render_ok(data: question)
    else
      render_error(message: 'Failed to load questions')
    end
  end

  def create
    question = Question.new(question_params)

    if question.save
      VerifyQuestionJob.perform_later(question)
      MailJob.perform_later(question)
      render_ok(data: question)
    else
      render_error(message: question.errors.messages)
    end
  end

  def update
    question = Question.unscoped.find_by(id: params[:id])
    if (current_user == question.user || current_user.is_admin) && question.update(question_params)
      VerifyQuestionJob.perform_later(question) unless current_user.is_admin
      render_ok(data: question)
    else
      render_error(message: question.errors.messages)
    end
  end

  def destroy
    question = Question.unscoped.find_by(id: params[:id])
    if (current_user == question.user || current_user.is_admin) && question.destroy
      render_ok(data: question)
    else
      render_error(message: question.errors.messages)
    end
  end

  def show
    authenticate_user if params[:authenticated]
    question = Question.find_by(id: params[:id])
    liked = Vote.exists?(voter_id: @current_user_id, votable: question)
    reported = Report.exists?(reporter_id: @current_user_id, reportable: question)
    if question
      render_ok(data: question.as_json.merge(liked: liked, comments: question.comments, reported: reported))
    else
      render_error(message: 'Not Found', status: 404)
    end
  end

  def latest
    authenticate_user if params[:authenticated]
    questions = Question.list.limit(4).order(created_at: :desc)
    likes = Vote.where(voter_id: @current_user_id)
    data = { questions: questions, likes: likes.pluck(:votable_id) }
    render_ok(data: data)
  end

  def search
    authenticate_user if params[:authenticated]
    questions = Question.list.search(params[:q]).order(created_at: :desc)
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
    questions = Question.list.hot.limit(6)
    if questions
      render_ok(data: questions)
    else
      render_error(message: 'Bad Request', status: 400)
    end
  end

  def interactive
    questions = Question.list.interactive.limit(5)
    if questions
      render_ok(data: questions)
    else
      render_error(message: 'Bad Request', status: 400)
    end
  end

  def top_tagging
    tag_names = ActsAsTaggableOn::Tag.most_used(1).map(&:name)
    questions = Question.list.tagged_with(tag_names).limit(4)
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
    questions = Question.list.tagged_with(params[:tag])
    likes = Vote.where(voter_id: @current_user_id, votable_id: questions.ids)
    data = { questions: questions, likes: likes.pluck(:votable_id) }
    render_ok(data: data)
  end

  private

  def question_params
    params.require(:question).permit(:excerpt, :content, :category_id, :user_id, :tag_list, :image, :visible)
  end
end
