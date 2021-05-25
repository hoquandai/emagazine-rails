class VotesController < ApplicationController
  before_action :authenticate_user

  def create
    vote = Vote.new(voter_type: 'User', voter_id: @current_user_id,
                    votable_type: 'Question', votable_id: params[:question_id])
    if vote.save
      render_ok(data: vote)
    else
      render_error(message: vote.errors.messages, status: 400)
    end
  end

  def remove
    votes = Vote.where(voter_type: 'User', voter_id: @current_user_id,
                       votable_type: 'Question', votable_id: params[:question_id])
    if votes.destroy_all
      render_ok(data: {})
    else
      render_error(message: 'Failed to unlike the question', status: 400)
    end
  end
end
