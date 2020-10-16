class Property < ActiveRecord::Base
    belongs_to :seller, class_name: "User"
    has_many :userProperties
    validates :seller_id, :address, :overview, :price, presence: true
end
