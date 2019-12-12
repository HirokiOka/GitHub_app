class CreateJsCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :js_codes do |t|
      t.text :filename
      t.text :html_url
      t.text :code

      t.timestamps
    end
  end
end
