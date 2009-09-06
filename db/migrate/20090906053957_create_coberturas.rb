class CreateCoberturas < ActiveRecord::Migration
  def self.up
    create_table :coberturas do |t|
      t.string :nombre
      t.integer :numero_de_nodo
      t.string :colonia
      t.string :calle
      t.integer :plaza_id

      t.timestamps
    end
  end

  def self.down
    drop_table :coberturas
  end
end
