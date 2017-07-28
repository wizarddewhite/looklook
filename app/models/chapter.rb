class Chapter < ApplicationRecord
  validates :start_second, numericality: { greater_than: 0}
  validates :title, presence: true

  belongs_to :video
end
