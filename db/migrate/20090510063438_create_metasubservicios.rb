class CreateMetasubservicios < ActiveRecord::Migration
  def self.up
    create_table :metasubservicios do |t|
      t.string :nombre
      t.integer :metaservicio_id

      t.timestamps
    end
  end

  def self.down
    drop_table :metasubservicios
  end
end
