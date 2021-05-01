class AddNameColumnToAuthTokens < ActiveRecord::Migration[6.0]
  def change
    add_column :auth_tokens, :name, :string
  end
end
