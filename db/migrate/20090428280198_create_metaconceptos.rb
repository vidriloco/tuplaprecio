class CreateMetaconceptos < ActiveRecord::Migration
  def self.up
    create_table :metaconceptos do |t|
      t.string :nombre
      t.string :tipo
      t.timestamps
    end
    
    create_table :metaconceptos_metaservicios, :id => false do |t|
      t.integer :metaservicio_id
      t.integer :metaconcepto_id
    end
    
    add_index :metaconceptos_metaservicios, :metaservicio_id
    add_index :metaconceptos_metaservicios, :metaconcepto_id
  end

  def self.down
    drop_table :metaconceptos
    drop_table :metaconceptos_metaservicios
  end
end
