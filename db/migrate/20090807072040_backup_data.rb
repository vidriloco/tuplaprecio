class BackupData < ActiveRecord::Migration
  def self.up
    create_table :backups do |b|
      b.string :security_hash
    end
  end

  def self.down
    drop_table :backups
  end
end
