class CreateEspecializados < ActiveRecord::Migration
  def self.up
    create_table :especializados do |t|
      t.float :costo
      t.boolean :activo
      t.integer :servicio_id
      t.integer :plaza_id
      t.timestamps
    end
  end

  def self.down
    drop_table :especializados
  end
end
