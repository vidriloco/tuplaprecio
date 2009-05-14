class CreateUsuarios < ActiveRecord::Migration
  def self.up
    create_table "usuarios", :force => true do |t|
      t.references :responsabilidad,       :polymorphic => true
      t.column :nombre,                    :string, :limit => 100, :default => '', :null => true
      t.column :login,                     :string, :limit => 40              
      t.column :email,                     :string, :limit => 100
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string, :limit => 40
      t.column :remember_token_expires_at, :datetime

      t.column :rol_id,                    :integer
    end
    add_index :usuarios, :login, :unique => true
    
  end

  def self.down
    drop_table "usuarios"
  end
end
