class CreateUserSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :user_sessions do |t|
      t.references :users, foreign_key: true
      t.references :servers, foreign_key: true
      t.references :auth_tokens, foreign_key: true
      t.integer :state

      t.timestamps
    end
  end
end
