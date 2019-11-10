class CreateAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :answers do |t|
      t.integer :code_id
      t.integer :user_id
      t.string :answer

      t.timestamps
    end
  end
end
