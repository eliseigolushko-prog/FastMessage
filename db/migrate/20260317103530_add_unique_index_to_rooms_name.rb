class AddUniqueIndexToRoomsName < ActiveRecord::Migration[7.2]
  def change
    add_index :rooms, :name, unique: true
  end
end
