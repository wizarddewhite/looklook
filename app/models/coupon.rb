class Coupon < ApplicationRecord
  before_create :generate_token
  validates :price, presence: true
  validates :quantity, presence: true

  belongs_to :course

  def generate_token
    self.token = SecureRandom.uuid
  end
end
