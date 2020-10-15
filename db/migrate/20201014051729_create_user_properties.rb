class CreateUserProperties < ActiveRecord::Migration
  def change
    create_table :user_properties do |t|
      t.integer :user_id
      t.integer :property_id
      t.string :message
      t.integer :applied, :default => 0
      t.timestamps null: false
    end
  end
end
