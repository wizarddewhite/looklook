class CourseCategory < ApplicationRecord
  validates :title, presence: true

  has_many :courses
end
