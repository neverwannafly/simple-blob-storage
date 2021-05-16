class FileNode < ApplicationRecord
  enum permissions: [:limited, :visible]
  belongs_to :file_system
end
