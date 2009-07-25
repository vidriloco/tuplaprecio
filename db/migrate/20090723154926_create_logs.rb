class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.integer :usuario_id
      t.string :accion
      t.references :recurso, :polymorphic => true
      t.timestamps
    end
  end

  def self.down
    drop_table :logs
  end
end
