class CreateFileNodes < ActiveRecord::Migration[6.0]
  def change
    create_table :file_nodes do |t|
      t.string :file_name
      t.string :file_size
      t.string :file_type
      t.integer :permissions

      t.timestamps
    end
  end
end
