# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  is_admin               :boolean          default(FALSE)
#  name                   :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  score                  :integer          default(0)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  include Rails.application.routes.url_helpers
  DEFAULT_AVATAR = ActionController::Base.helpers.asset_path 'img01.jpg'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions
  has_one_attached :avatar

  validates :name, uniqueness: { case_sensitive: false },
                   presence: true,
                   allow_blank: false,
                   format: { with: /\A[a-zA-Z0-9]+\z/ }
  scope :top_ranking, lambda {
    order(score: :desc).limit(5)
  }

  def generate_jwt
    JWT.encode({ id: id, exp: 60.days.from_now.to_i }, Rails.application.secrets.secret_key_base)
  end

  def avatar_path
    avatar.attached? ? rails_blob_path(avatar, only_path: true) : DEFAULT_AVATAR
  end

  def as_json(data = {})
    avatar_url = avatar.attached? ? rails_blob_path(avatar, only_path: true) : DEFAULT_AVATAR
    super(data).merge({
      avatar: avatar_url
    })
  end
end
