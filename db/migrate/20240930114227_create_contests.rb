class CreateContests < ActiveRecord::Migration[7.1]
  def change
    create_table :contests do |t|
      t.string :title, null: false, index: { unique: true, name: 'unique_contest_title' }
      t.text :description, null: false
      t.datetime :start_date, null: false, index: true
      t.datetime :end_date, null: false, index: true

      t.timestamps
    end

    add_index :contests, :created_at
  end
end
