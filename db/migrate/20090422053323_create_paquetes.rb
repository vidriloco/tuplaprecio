class CreatePaquetes < ActiveRecord::Migration
  def self.up
    create_table :paquetes do |t|
      t.float    :costo_1_10
      t.float    :costo_11_31
      t.float    :costo_real
      t.float    :ahorro
      t.integer  :numero_de_servicios
      t.string   :television
      t.string   :telefonia
      t.string   :internet

      t.integer  :plaza_id
      t.timestamps
    end

  end

  def self.down
    drop_table :paquetes
  end
end
