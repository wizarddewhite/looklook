class Course < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true

  belongs_to :user
  has_many :course_user_relationships
  has_many :students, :through => :course_user_relationships, :source => :user
end
