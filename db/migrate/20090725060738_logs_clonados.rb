class LogsClonados < ActiveRecord::Migration
  def self.up
    create_table :servicio_clones do |t|
      # Siguientes dos representan información dada por plaza.
      t.string :plaza_nombre
      t.string :estado_nombre
      # Siguientes dos representan información dada por metasubservicio.
      t.string :metasubservicio_nombre
      t.string :metaservicio_nombre
    end
    
    create_table :concepto_clones do |t|
      t.boolean :disponible
      t.integer :valor
      t.float   :costo
      t.text    :comentarios
      t.integer :servicio_clon_id
      t.string  :metaconcepto_nombre
      t.string  :metaconcepto_tipo
    end
    
    create_table :paquete_clones do |t|
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
    end
    
    
  end

  def self.down
    drop_table :paquete_clones
    drop_table :concepto_clones
    drop_table :servicio_clones 
  end
end
