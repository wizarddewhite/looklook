class SlCategory < ApplicationRecord
  validates :title, presence: true
  validates :fl_category_id, presence: true

  belongs_to :fl_category
  has_many :course_categories
end
