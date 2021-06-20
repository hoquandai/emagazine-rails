class MailJob < ApplicationJob
  queue_as :default

  def perform(question)
    QuestionMailer.send_notification(question).deliver_now
  end
end
