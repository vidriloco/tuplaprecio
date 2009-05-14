class CreateIncorporados < ActiveRecord::Migration
  def self.up
    create_table :incorporados do |t|
      t.float :costo
      t.integer :servicio_id
      t.integer :paquete_id
      t.date :vigente_desde
      t.date :vigente_hasta
      t.string :detalles
      t.timestamps
    end
  end

  def self.down
    drop_table :incorporados
  end
end
