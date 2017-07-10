class Course < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :course_category_id, presence: true

  belongs_to :user
  has_many :course_user_relationships
  has_many :students, :through => :course_user_relationships, :source => :user

  belongs_to :course_category

  def publish!
    self.is_hidden = false
    self.save
  end

  def hide!
    self.is_hidden = true
    self.save
  end
end
