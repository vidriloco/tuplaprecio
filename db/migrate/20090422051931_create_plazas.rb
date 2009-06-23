class CreatePlazas < ActiveRecord::Migration
  def self.up
    create_table :plazas do |t|
      t.string :nombre
      t.integer :estado_id

      t.timestamps
    end
  end

  def self.down
    drop_table :plazas
  end
end
