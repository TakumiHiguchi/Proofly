class CreateFixedPages < ActiveRecord::Migration[5.1]
  def change
    create_table :fixed_pages do |t|
      t.string :fix_key
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
