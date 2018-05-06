class AddRandomKeyToPost < ActiveRecord::Migration[5.1]
  def change
  	add_column :posts, :random_key, :string
  end
end
