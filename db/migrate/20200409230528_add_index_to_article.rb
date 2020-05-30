class AddIndexToArticle < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :index, :boolean, default: false, null: false
  end
end
