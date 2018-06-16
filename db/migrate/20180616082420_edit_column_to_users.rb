class EditColumnToUsers < ActiveRecord::Migration[5.1]
  def change
  	rename_column :users, :image, :image_url
  	add_column :users, :image, :string
  end
end
