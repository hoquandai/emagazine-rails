class VerifyQuestionJob < ApplicationJob
  queue_as :default

  def perform(question)
    VerifyQuestionService.call question
  end
end
