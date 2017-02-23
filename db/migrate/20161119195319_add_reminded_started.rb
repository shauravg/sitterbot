class AddRemindedStarted < ActiveRecord::Migration
  def change
    add_column :events, :reminded, :boolean, default: false
    add_column :events, :started, :boolean, default: false
  end
end
