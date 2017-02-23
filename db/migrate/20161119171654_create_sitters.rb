class CreateSitters < ActiveRecord::Migration
  def change
    create_table :sitters do |t|
      t.integer :parent_id, null: false, index: true
      t.boolean :paid, default: true
      t.integer :hourly_rate, default: 10
      t.string :phone
      t.string :email
      t.string :name, null: false
      t.boolean :can_drive, default: true
      t.integer :per_extra_kid

      t.timestamps null: false
    end
  end
end
