class LogsClonados < ActiveRecord::Migration
  def self.up
    create_table :servicios_clon do |t|
      # Siguientes dos representan información dada por plaza.
      t.string :plaza_nombre
      t.string :estado_nombre
      # Siguientes dos representan información dada por metasubservicio.
      t.string :nombre_metasubservicio
      t.string :nombre_metaservicio
      t.timestamps
    end
    
    create_table :conceptos_clon do |t|
      
    end
    
    create_table :paquetes_clon do |t|
      t.float    :costo_1_10
      t.float    :costo_11_31
      t.float    :costo_real
      t.float    :ahorro
      t.integer  :numero_de_servicios
      t.string   :television
      t.string   :telefonia
      t.string   :internet

      # Siguientes dos representan información dada por plaza.
      t.string :plaza_nombre
      t.string :estado_nombre
      # Siguiente representa sobre zona.
      t.string  :zona_nombre
      t.timestamps
    end
    
    
  end

  def self.down
  end
end
