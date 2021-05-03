class FileSystem < ApplicationRecord
  enum permissions: [:private, :public]
end
