class CreateServicios < ActiveRecord::Migration
  def self.up
    create_table :servicios do |t|
      t.integer :plaza_id
      t.integer :metasubservicio_id
      t.timestamps
    end
  end

  def self.down
    drop_table :servicios
  end
end
