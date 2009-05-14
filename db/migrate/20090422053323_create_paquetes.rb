class CreatePaquetes < ActiveRecord::Migration
  def self.up
    create_table :paquetes do |t|
      t.string :nombre

      t.timestamps
    end
    
    create_table :paquetes_plazas, :id => false do |t|
      t.integer :plaza_id
      t.integer :paquete_id
    end
    add_index :paquetes_plazas, :plaza_id
    add_index :paquetes_plazas, :paquete_id
    
    #create_table :paquetes_servicios, :id => false do |t|
    #  t.integer :servicio_id
    #  t.integer :paquete_id
    #end
    #add_index :paquetes_servicios, :servicio_id
    #add_index :paquetes_servicios, :paquete_id
  end

  def self.down
    drop_table :paquetes
    drop_table :paquetes_plazas
    #drop_table :paquetes_servicios
  end
end
