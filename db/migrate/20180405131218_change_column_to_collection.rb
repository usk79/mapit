class ChangeColumnToCollection < ActiveRecord::Migration[5.1]
  def change
    rename_column :collections, :type, :collection_type
  end
end
