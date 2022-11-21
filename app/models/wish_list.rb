class WishList < ApplicationRecord
  # paranoid
  acts_as_paranoid

  # validations
  validates :title, presence: true
  validates :description, presence: true

  # relationships
  belongs_to :user
  has_many :comments
end