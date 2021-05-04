class CreateComment < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :question, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :excerpt
      t.text :content

      t.timestamps
    end
  end
end
