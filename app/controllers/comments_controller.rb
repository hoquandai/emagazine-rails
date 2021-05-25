class CommentsController < ApplicationController
  def create
    comment = Comment.new(comment_params)
    if comment.save
      render_ok(data: comment)
    else
      render_error(message: comment.errors.messages, status: 400)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :question_id, :user_id)
  end
end
