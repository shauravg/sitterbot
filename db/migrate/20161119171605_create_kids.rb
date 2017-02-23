class CreateKids < ActiveRecord::Migration
  def change
    create_table :kids do |t|
      t.integer :parent_id, null: false, index: true
      t.string :nickname, null: false
      t.date :birthdate
      t.text :instructions

      t.timestamps null: false
    end
  end
end
