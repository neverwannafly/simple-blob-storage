class CreateServers < ActiveRecord::Migration[6.0]
  def change
    create_table :servers do |t|
      t.string :name
      t.string :host
      t.string :port
      t.bigint :uptime
      t.integer :server_type
      t.integer :status
      t.integer :state
      t.string :secret_key #encrypted

      t.timestamps
    end
  end
end
