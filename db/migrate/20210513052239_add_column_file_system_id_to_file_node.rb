class AddColumnFileSystemIdToFileNode < ActiveRecord::Migration[6.0]
  def change
    add_column :file_nodes, :file_system_id, :integer
    add_column :file_systems, :node_name, :string

    remove_column :file_nodes, :file_name, :string
  end
end
