class AddColumnToPosts < ActiveRecord::Migration[5.1]
  def change
  	add_column :posts, :question, :string
  	add_column :posts, :answer, :string
  end
end
