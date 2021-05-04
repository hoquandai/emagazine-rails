class CreateReport < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.references :reporter, polymorphic: true, null: false
      t.references :reportable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
