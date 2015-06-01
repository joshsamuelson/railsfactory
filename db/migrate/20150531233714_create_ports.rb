class CreatePorts < ActiveRecord::Migration
  def change
    create_table :ports do |t|
      t.belongs_to :user, index: true
      t.integer :dest_port
      t.timestamps null: false
    end
  end
end
