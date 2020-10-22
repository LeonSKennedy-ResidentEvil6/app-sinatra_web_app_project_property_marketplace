class Property < ActiveRecord::Base
    belongs_to :seller, class_name: 'User'
    validates :seller_id, :address, :overview, :price, presence: true
  end