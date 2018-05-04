class CreateAnswerHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :answer_histories do |t|
      t.integer :post_id
      t.integer :user_id
      t.integer :number

      t.timestamps
    end
  end
end
