class CourseCategory < ApplicationRecord
  validates :title, presence: true
  validates :sl_category_id, presence: true

  belongs_to :sl_category
  has_many :courses
end
