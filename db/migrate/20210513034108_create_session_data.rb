class CreateSessionData < ActiveRecord::Migration[6.0]
  def change
    create_table :session_data do |t|
      t.integer :active_node
      t.text :history

      t.timestamps
    end
  end
end
