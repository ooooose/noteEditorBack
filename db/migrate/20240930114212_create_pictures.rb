class CreatePictures < ActiveRecord::Migration[7.1]
  def change
    create_table :pictures do |t|
      t.references :user, null: false, foreign_key: true
      t.references :theme, null: false, foreign_key: true
      t.string :uid, null: false, index: { unique: true, name: 'unique_picture_uid' }
      t.text :image_url, null: false
      t.integer :frame_id, null: false, default: 0

      t.timestamps
    end

    add_index :pictures, [:user_id, :theme_id], unique: true
    add_index :pictures, :created_at
  end
end
