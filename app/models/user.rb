class User < ApplicationRecord
  has_secure_password
  
  before_save { self.email.downcase! }
  
  #TODO: ユーザ名をアルファベットと少しの記号のみに制限する
  validates :name, presence: true, length: { minimum: 4, maximum: 40 },
                    uniqueness: { case_sensitive: false }
  
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
                    
  has_many :collections, dependent: :destroy
  has_many :collection_relationships, dependent: :destroy
  has_many :follow_collections, through: :collection_relationships, source: :collection
  
  has_many :comments, dependent: :destroy
  
  def follow(collection)
    self.collection_relationships.find_or_create_by(collection_id: collection.id)
  end
  
  def unfollow(collection)
    relationship = self.collection_relationships.find_by(collection_id: collection.id)
    relationship.destroy if relationship
  end
  
  def following?(collection)
    self.follow_collections.include?(collection)
  end
  
  def is_creator?(collection)
    self.id == collection.created_by
  end
  
end
