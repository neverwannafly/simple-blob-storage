class FileSystem < ApplicationRecord
  enum permissions: [:limited, :visible]
  enum node_type: [:file, :folder]

  has_one :file_node

  def get_children
    FileSystem.left_outer_joins(:file_nodes).where(parent: self.id)
  end

  def get_node_address
    current_file = self
    file_components = []
    while current_file.present?
      file_components << [current_file.node_name]
      current_file = FileSystem.where(id: current_file.parent_id).first
    end

    address = file_components.reverse.join("/")
  end

  def get_disk_address
    file_type = self.file_node.file_type
    "rpc-server/db/#{self.get_node_address}.#{file_type.split('/')[-1]}"
  end

  def self.create_file(parent_id:, owner_id:, file_name:, file_size:, file_type:, permission: :limited)
    ActiveRecord::Base.transaction do
      fs = self.create!(
        owner_id: owner_id,
        node_type: :file,
        parent_id: parent_id,
        node_name: file_name,
        permissions: permission
      )
      FileNode.create!(
        file_system_id: fs.id,
        file_size: file_size,
        file_type: file_type,
        permissions: permission
      )
    end
  end

  def self.create_directory(parent_id:, owner_id:, directory_name:, permission: :limited)
    self.create!(
      owner_id: owner_id,
      node_type: :folder,
      parent_id: parent_id,
      node_name: directory_name,
      permissions: permission
    )
  end
end
