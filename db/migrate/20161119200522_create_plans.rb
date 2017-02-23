class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.string :stripe_id, null: false
      t.integer :price
      t.string :interval
      t.text :features
      t.boolean :highlight
      t.integer :display_order

      t.timestamps null: false
    end
  end
end
