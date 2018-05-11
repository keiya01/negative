class AddCheckToAnswerHistory < ActiveRecord::Migration[5.1]
  def change
  	add_column :answer_histories, :check, :boolean, default: true, null: false
  end
end
