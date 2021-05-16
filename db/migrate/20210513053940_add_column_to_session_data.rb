class AddColumnToSessionData < ActiveRecord::Migration[6.0]
  def change
    add_column :session_data, :user_session_id, :integer
  end
end
