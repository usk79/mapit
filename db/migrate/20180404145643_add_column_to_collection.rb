class AddColumnToCollection < ActiveRecord::Migration[5.1]
  def change
    add_column :collections, :type, :integer
    add_column :collections, :created_by, :integer
  end
end
