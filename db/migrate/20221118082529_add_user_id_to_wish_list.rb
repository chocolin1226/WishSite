class AddUserIdToWishList < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :wish_lists, :user
  end
end
