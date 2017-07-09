class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :nickname, presence: true

  scope :name_alphabetical, -> { order('nickname ASC') }
  scope :name_alphabetical_rev, -> { order('nickname DESC') }

  has_many :courses
  has_many :course_user_relationships
  has_many :participated_courses, :through => :course_user_relationships, :source => :course

  def has_joined_course?(course)
    participated_courses.include?(course)
  end

  def join!(course)
    participated_courses << course
  end

  def quit!(course)
    participated_courses.delete(course)
  end
end
