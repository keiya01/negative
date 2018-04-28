class AddCheckCountToPosts < ActiveRecord::Migration[5.1]
  def change
  	add_column :posts, :check_count, :integer
  end
end
