class AddExcerptToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :excerpt, :string
  end
end
