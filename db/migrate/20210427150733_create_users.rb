class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username, unique: true, index: true
      t.string :email, unique: true, index: true
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
