class CreateCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :codes do |t|
      t.text :language
      t.text :code

      t.timestamps
    end
  end
end
