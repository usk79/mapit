class Collection < ApplicationRecord
  belongs_to :user
  
  validates :name, length: {maximum: 50}
  validates :collection_type, numericality: {
            only_integer: true, 
            greater_than_or_equal_to: 0,
            less_than_or_equal_to: 1
          }
  
  has_many :points, dependent: :destroy
  has_many :collection_relationships, dependent: :destroy
  has_many :followers, through: :collection_relationships, source: :user
  
  mount_uploader :image, ImageUploader
  
  def is_private?
    self.collection_type == 1
  end
  
  def is_public?
    self.collection_type == 0
  end
  
  def creator
    User.find_by(id: self.created_by)
  end
end
