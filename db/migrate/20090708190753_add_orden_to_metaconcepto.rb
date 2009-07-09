class AddOrdenToMetaconcepto < ActiveRecord::Migration
  def self.up
    add_column :metaconceptos, :posicion, :integer
  end

  def self.down
    remove_column :metaconceptos, :posicion
  end
end
