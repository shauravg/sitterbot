class AddOrdToSitters < ActiveRecord::Migration
  def change
    add_column :sitters, :ord, :integer, default: 0
  end
end
