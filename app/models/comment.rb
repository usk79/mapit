class Comment < ApplicationRecord
  belongs_to :point
  belongs_to :user
  
  validates :content, presence: true
end
