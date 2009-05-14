class CreateCategorias < ActiveRecord::Migration
  def self.up
    create_table :categorias do |t|
      t.string :nombre

      t.timestamps
    end
    create_table :categorias_conceptos, :id => false do |t|
      t.integer :concepto_id
      t.integer :categoria_id
    end
    add_index :categorias_conceptos, :categoria_id
    add_index :categorias_conceptos, :concepto_id
    
  end

  def self.down
    drop_table :categorias
    drop_table :categorias_conceptos
  end
end
