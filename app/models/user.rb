class User < ActiveRecord::Base
    has_secure_password
    has_many :properties
    has_many :userProperties
    validates :full_name, :username, :email, presence: true
  end