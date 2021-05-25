# == Schema Information
#
# Table name: comments
#
#  id          :bigint           not null, primary key
#  content     :text(65535)
#  excerpt     :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_comments_on_question_id  (question_id)
#  index_comments_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (question_id => questions.id)
#  fk_rails_...  (user_id => users.id)
#
class Comment < ApplicationRecord
  belongs_to :question
  belongs_to :user

  def as_json(data = {})
    {
      id: id,
      content: content,
      excerpt: excerpt,
      created_at: created_at,
      creator: user,
      question: question
    }
  end
end
