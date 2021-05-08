# == Schema Information
#
# Table name: reports
#
#  id              :bigint           not null, primary key
#  reportable_type :string(255)      not null
#  reporter_type   :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  reportable_id   :bigint           not null
#  reporter_id     :bigint           not null
#
# Indexes
#
#  index_reports_on_reportable  (reportable_type,reportable_id)
#  index_reports_on_reporter    (reporter_type,reporter_id)
#
class Report < ApplicationRecord
  belongs_to :reporter, polymorphic: true
  belongs_to :reportable, polymorphic: true
end
