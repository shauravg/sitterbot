class CreateEventRequests < ActiveRecord::Migration
  def change
    create_table :event_requests do |t|
      t.integer :event_id, null: false, index: true
      t.integer :sitter_id, null: false, index: true
      t.boolean :texted, default: false
      t.boolean :emailed, default: false
      t.integer :state, default: 0

      t.timestamps null: false
    end
  end
end
