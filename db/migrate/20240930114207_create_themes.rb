class CreateThemes < ActiveRecord::Migration[7.1]
  def change
    create_table :themes do |t|
      t.string :title, null: false, index: { unique: true, name: 'unique_theme_title' }

      t.timestamps
    end
  end
end
