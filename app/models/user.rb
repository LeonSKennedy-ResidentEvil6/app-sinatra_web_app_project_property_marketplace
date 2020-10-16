class User < ActiveRecord::Base
    has_secure_password
    has_many :properties
    has_many :userProperties
    # validates is used to require input for certain attribute
    validates :first_name, :last_name, :username, :email, presence: true    
end
