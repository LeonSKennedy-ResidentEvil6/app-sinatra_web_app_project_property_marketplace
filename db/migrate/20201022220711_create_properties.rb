class CreateProperties < ActiveRecord::Migration
  def change
      create_table :properties do |t|
      t.string :address
      t.string :picture
      t.string :overview
      t.integer :price
      t.integer :seller_id
      end 
  end
end
