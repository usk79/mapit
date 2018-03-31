class CreatePoints < ActiveRecord::Migration[5.1]
  def change
    create_table :points do |t|
      t.string :name
      t.float :lat
      t.float :lng
      t.text :description
      t.text :address
      t.integer :created_by

      t.timestamps
    end
  end
end
