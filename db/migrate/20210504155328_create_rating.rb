class CreateRating < ActiveRecord::Migration[6.1]
  def change
    create_table :ratings do |t|
      t.references :rater, polymorphic: true, null: false
      t.references :ratable, polymorphic: true, null: false
      t.integer :score

      t.timestamps
    end
  end
end
