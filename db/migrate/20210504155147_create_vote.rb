class CreateVote < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.references :voter, polymorphic: true, null: false
      t.references :votable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
