class CreateBadges < ActiveRecord::Migration[7.1]
  def change
    create_table :badges do |t|
      t.references :pictures, null: false, foreign_key: true
      t.references :contests, null: false, foreign_key: true
      t.timestamps
    end
  end
end
