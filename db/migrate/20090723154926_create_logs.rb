class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.integer :usuario_id
      t.string :accion
      t.references :recurso, :polymorphic => true
      t.timestamp :fecha_de_creacion
    end
  end

  def self.down
    drop_table :logs
  end
end
