class CourseCategory < ApplicationRecord
  validates :title, presence: true
end
