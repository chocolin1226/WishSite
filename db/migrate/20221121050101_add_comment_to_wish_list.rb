# frozen_string_literal: true

class AddCommentToWishList < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :comments, :wish_list
  end
end
