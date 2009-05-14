class CreateAdministraciones < ActiveRecord::Migration
  def self.up
    create_table :administraciones do |t|
      # Niveles de asignación de roles de acuerdo a permisos
      t.string :nivel_alto
      t.string :nivel_medio
      t.string :nivel_bajo
      t.timestamps
    end
  end

  def self.down
    drop_table :administraciones
  end
end
