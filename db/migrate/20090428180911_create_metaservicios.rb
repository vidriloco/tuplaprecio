class CreateMetaservicios < ActiveRecord::Migration
  def self.up
    create_table :metaservicios do |t|
      t.string :nombre
      t.timestamps
    end
  end

  def self.down
    drop_table :metaservicios
  end
end
