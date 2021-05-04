class CreateQuestion < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.references :category, null: false, foreign_key: true
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.boolean :visible

      t.timestamps
    end
  end
end
