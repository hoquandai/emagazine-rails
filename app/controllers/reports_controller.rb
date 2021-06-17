class ReportsController < ApplicationController
  before_action :authenticate_user

  def create
    report = Report.new(reporter_type: 'User', reporter_id: @current_user_id,
                        reportable_type: 'Question', reportable_id: params[:question_id])
    if report.save
      render_ok(data: report)
    else
      render_error(message: report.errors.messages, status: 400)
    end
  end

  def remove
    reports = Report.where(reporter_type: 'User', reporter_id: @current_user_id,
                           reportable_type: 'Question', reportable_id: params[:question_id])
    if reports.destroy_all
      render_ok(data: {})
    else
      render_error(message: 'Failed to unlike the question', status: 400)
    end
  end
end
