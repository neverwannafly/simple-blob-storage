class CreateUserSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :user_sessions do |t|
      t.references :user, foreign_key: true
      t.references :server, foreign_key: true
      t.references :auth_token, foreign_key: true
      t.integer :state

      t.timestamps
    end
  end
end
