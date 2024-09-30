class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :picture, null: false, foreign_key: true
      t.text :body, null: false, limit: 200

      t.timestamps
    end
  end
end
