class CreateServicios < ActiveRecord::Migration
  def self.up
    create_table :servicios do |t|
      t.text :detalles
      t.integer :concepto_id
      t.integer :categoria_id
      t.timestamps
    end
  end

  def self.down
    drop_table :servicios
  end
end
