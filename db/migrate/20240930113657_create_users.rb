class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, null: false, limit: 40
      t.string :uid, null: false, index: { unique: true, name: 'unique_user_uid' }
      t.string :email, null: false, index: { unique: true, name: 'unique_user_emails' }
      t.string :image
      t.integer :role, null: false, default: 1

      t.timestamps null: false
      t.datetime :deleted_at, index: true
    end
  end
end
