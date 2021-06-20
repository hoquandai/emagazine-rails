class QuestionMailer < ApplicationMailer
  def send_notification(question)
    @question = question
    mail to: 'admin@mail.com', subject: 'New Question Added'
  end
end
