class Collection < ApplicationRecord
  belongs_to :user
  
  validates :name, length: {maximum: 255}
  validates :collection_type, numericality: {
            only_integer: true, 
            greater_than_or_equal_to: 0,
            less_than_or_equal_to: 1
          }
  
  has_many :points, dependent: :destroy
  has_many :collection_relationships, dependent: :destroy
  has_many :followers, through: :collection_relationships, source: :user

end
