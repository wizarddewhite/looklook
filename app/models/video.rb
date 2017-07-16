class Video < ApplicationRecord
  #validates :hashid, presence: true

  belongs_to :course
end
