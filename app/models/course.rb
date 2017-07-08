class Course < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true

  belongs_to :user
end
