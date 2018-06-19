class RenameImageUrlToUsers < ActiveRecord::Migration[5.1]
  def change
  	rename_column :users, :image_url, :icon_url
  end
end
