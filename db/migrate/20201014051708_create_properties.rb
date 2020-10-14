class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :address
      t.string :overview
      t.integer :price
      t.integer :seller_id
      t.timestamps null: false
    end
  end
end
