class CreateConceptos < ActiveRecord::Migration
  def self.up
    create_table :conceptos do |t|
      t.string :nombre
      t.timestamps
    end
  end

  def self.down
    drop_table :conceptos
  end
end
