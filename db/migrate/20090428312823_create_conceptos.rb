class CreateConceptos < ActiveRecord::Migration
  def self.up
    create_table :conceptos do |t|
      t.boolean :disponible
      t.integer :valor
      t.float :costo
      t.text :comentarios
      
      t.integer :servicio_id
      t.integer :metaconcepto_id
      t.timestamps
    end
  end

  def self.down
    drop_table :conceptos
  end
end
