class CreateUsers < ActiveRecord::Migration
  def change
      create_table :users do |t|
        t.string :full_name
        t.string :username
        t.string :email
        t.string :password_digest
        t.boolean :seller
        t.string :biography
      end
  end
end

