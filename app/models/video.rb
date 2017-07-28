class Video < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true

  belongs_to :course
  has_many :chapters

end
