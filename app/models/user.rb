class User < ApplicationRecord
  has_secure_password
  
  before_save { self.email.downcase! }
  
  validates :name, presence: true, length: { minimum: 4, maximum: 50 },
                    uniqueness: { case_sensitive: false }
  
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
end
