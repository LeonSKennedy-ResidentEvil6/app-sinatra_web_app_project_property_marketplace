class CreateUserProperties < ActiveRecord::Migration
  def change
    create_table :user_properties do |t|
      t.integer :seller_id
      t.integer :buy_id
      t.string :message
      t.integer :applied, :default => 0
      t.timestamps null: false
    end
  end
end
