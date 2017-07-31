class FlCategory < ApplicationRecord
  validates :title, presence: true

  has_many :sl_categories
end
