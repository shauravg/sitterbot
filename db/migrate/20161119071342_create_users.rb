class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest
      t.string :session_token, null: false
      t.string :reset_token
      t.string :selected_plan

      t.timestamps null: false
    end

    add_index :users, :email
  end
end
