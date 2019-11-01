class AddHtmlUrlToCodes < ActiveRecord::Migration[6.0]
  def change
    add_column :codes, :html_url, :text
  end
end
