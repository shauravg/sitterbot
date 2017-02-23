class CreateSslVerifications < ActiveRecord::Migration
  def change
    create_table :ssl_verifications do |t|
      t.string :key
      t.string :value

      t.timestamps null: false
    end
  end
end
