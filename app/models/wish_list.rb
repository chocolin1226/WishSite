# frozen_string_literal: true

class WishList < ApplicationRecord
  # paranoid
  acts_as_paranoid

  # validations
  validates :title, presence: true
  validates :description, presence: true

  # relationships
  belongs_to :user
  has_many :comments

  has_many :like_wish_lists
  has_many :liked_users, through: :like_wish_lists, source: :user

  def liked_by?(user)
    liked_users.include?(user)
  end
end
