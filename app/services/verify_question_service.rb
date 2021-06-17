class VerifyQuestionService < ApplicationService
  private

  def initialize(question)
    @question = question
  end

  def call
    flag = false
    if check_ng_words(@question.content) || check_ng_words(@question.excerpt)
      @question.visible = false
    else
      @question.visible = true
    end
    @question.save

    flag
  end

  def ng_words
    Rails.cache.fetch('ng_words', expires_in: 604_800) do
      f = File.open(Rails.root.join('db/data/NG_words.txt'), 'r')
      ngwords = f.readlines.map(&:chomp)
      ngwords.map!(&:downcase)
    end
  end

  def check_ng_words(str)
    ng_words.any? { |x| str.downcase.include?(x) }
  end
end
