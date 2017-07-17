class Video < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true

  belongs_to :course

end
