# == Schema Information
#
# Table name: questions
#
#  id          :bigint           not null, primary key
#  content     :text(65535)
#  excerpt     :string(255)
#  visible     :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_questions_on_category_id  (category_id)
#  index_questions_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#
class Question < ApplicationRecord
  include Rails.application.routes.url_helpers
  DEFAULT_IMAGE = ActionController::Base.helpers.asset_path 'img04.jpg'

  default_scope { where(visible: true) }

  acts_as_taggable

  belongs_to :category
  belongs_to :user
  has_many :votes, as: :votable, dependent: :destroy
  has_many :reports, as: :reportable, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :image, dependent: :destroy

  scope :hot, lambda {
    Question.left_joins(:votes).group(:id).order('COUNT(votes.votable_id) DESC')
  }

  scope :interactive, lambda {
    Question.left_joins(:comments).group(:id).order('COUNT(comments.question_id) DESC')
  }

  scope :search, lambda { |keyword|
    return Question.all if keyword.blank?

    Question.where('excerpt LIKE ?', "%#{keyword}%").or(Question.where('content LIKE ?', "%#{keyword}%"))
  }

  scope :list, lambda {
    includes(:user, :category, :votes, :tags, image_attachment: :blob)
  }

  def as_json(data = {})
    {
      id: id,
      excerpt: excerpt,
      content: content,
      created_at: created_at.strftime('%H:%M %d %B, %Y'),
      creator: user,
      category: category,
      tags: tags,
      likes: votes.size,
      reports: reports.size,
      image: image.attached? ? rails_blob_path(image, only_path: true) : DEFAULT_IMAGE,
      visible: visible
    }
  end
end
