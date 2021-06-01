# == Schema Information
#
# Table name: votes
#
#  id           :bigint           not null, primary key
#  votable_type :string(255)      not null
#  voter_type   :string(255)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  votable_id   :bigint           not null
#  voter_id     :bigint           not null
#
# Indexes
#
#  index_votes_on_votable  (votable_type,votable_id)
#  index_votes_on_voter    (voter_type,voter_id)
#
class Vote < ApplicationRecord
  after_create :increase_score
  after_destroy :decrease_score

  belongs_to :voter, polymorphic: true
  belongs_to :votable, polymorphic: true

  private

  def increase_score
    votable.user.score = votable.user.score + 1
    votable.user.save
  end

  def decrease_score
    votable.user.score = votable.user.score - 1
    votable.user.save
  end
end
