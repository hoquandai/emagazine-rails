# == Schema Information
#
# Table name: categories
#
#  id          :bigint           not null, primary key
#  description :text(65535)
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Category < ApplicationRecord
  has_many :questions
end
