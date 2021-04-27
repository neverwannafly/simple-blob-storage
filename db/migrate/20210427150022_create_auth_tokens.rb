class CreateAuthTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :auth_tokens do |t|
      t.text :token
      t.integer :scope
      t.integer :status
      t.references :bearer, polymorphic: true, index: true
      
      t.timestamps
    end
  end
end
