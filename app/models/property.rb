class Property < ActiveRecord::Base
    has_many :properties
    has_many :userProperties
    # validates is used to require input for certain attribute
    validates :first_name, :last_name, :username, :email, presence: true
end
