class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :nickname, presence: true

  scope :name_alphabetical, -> { order('nickname ASC') }
  scope :name_alphabetical_rev, -> { order('nickname DESC') }
end
