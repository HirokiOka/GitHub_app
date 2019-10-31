class AddFavorieLangToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :favorite_lang, :string
  end
end
