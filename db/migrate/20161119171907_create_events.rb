class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.boolean :food_included, default: false
      t.datetime :starts_at, null: false, null: false
      t.datetime :ends_at, null: false
      t.string :key, null: false
      t.integer :sitter_id, null: false, index: true
      t.integer :parent_id, null: false, index: true
      t.integer :flat_rate

      t.timestamps null: false
    end
  end
end
