class AddImageToPoints < ActiveRecord::Migration[5.1]
  def change
    add_column :points, :image, :string
  end
end
