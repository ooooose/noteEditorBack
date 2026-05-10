class AddOgpImageUrlToPictures < ActiveRecord::Migration[7.1]
  def change
    add_column :pictures, :ogp_image_url, :string
  end
end
