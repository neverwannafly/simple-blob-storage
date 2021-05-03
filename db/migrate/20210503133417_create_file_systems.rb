class CreateFileSystems < ActiveRecord::Migration[6.0]
  def change
    create_table :file_systems do |t|
      t.integer :node_type
      t.integer :permissions
      t.integer :parent_id, default: 0
      t.references :owner, references: :users

      t.timestamps
    end
  end
end
