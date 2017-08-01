class Chapter < ApplicationRecord
  validates :start_second, numericality: { greater_than_or_equal_to: 0}
  validates :title, presence: true

  belongs_to :video
end
