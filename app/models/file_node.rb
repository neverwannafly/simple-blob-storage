class FileNode < ApplicationRecord
  enum permissions: [:private, :public]
end
