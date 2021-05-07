class CreateUserSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :user_sessions do |t|
      t.references :user, index: true
      t.references :server, index: true
      t.references :auth_token, index: true
      t.integer :state

      t.timestamps
    end
  end
end
