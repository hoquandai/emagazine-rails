# == Schema Information
#
# Table name: ratings
#
#  id           :bigint           not null, primary key
#  ratable_type :string(255)      not null
#  rater_type   :string(255)      not null
#  score        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  ratable_id   :bigint           not null
#  rater_id     :bigint           not null
#
# Indexes
#
#  index_ratings_on_ratable  (ratable_type,ratable_id)
#  index_ratings_on_rater    (rater_type,rater_id)
#
class Rating < ApplicationRecord
  belongs_to :rater, polymorphic: true
  belongs_to :ratable, polymorphic: true
end
