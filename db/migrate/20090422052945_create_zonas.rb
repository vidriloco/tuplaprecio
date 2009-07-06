class CreateZonas < ActiveRecord::Migration
  def self.up
    create_table :zonas do |t|
      t.string :nombre

      t.timestamps
    end
  end

  def self.down
    drop_table :zonas
  end
end
