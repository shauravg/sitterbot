class NoSitterOnEvent2 < ActiveRecord::Migration
  def change
    change_column :events, :sitter_id, :integer, null: true
  end
end
