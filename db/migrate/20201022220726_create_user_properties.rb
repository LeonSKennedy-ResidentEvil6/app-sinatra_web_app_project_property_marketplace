class CreateUserProperties < ActiveRecord::Migration
  def change
    create_table :user_properties do |t|
    t.integer :applied, :default => 0
    t.string :message
    t.integer :user_id
    t.integer :property_id
  end 
end
end
