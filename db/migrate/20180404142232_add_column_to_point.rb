class AddColumnToPoint < ActiveRecord::Migration[5.1]
  def change
    add_reference :points, :collection, foreign_key: true
  end
end
