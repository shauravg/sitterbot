class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :stripe_id
      t.integer :plan_id, null: false, index: true
      t.string :last_four
      t.integer :coupon_id
      t.string :card_type
      t.integer :current_price
      t.integer :parent_id
      t.datetime :paid_thru
      t.string :credit_card_token

      t.timestamps null: false
    end
  end
end
