class AddTestModels < ActiveRecord::Migration
  def self.up
     rol1=Rol.create(:nombre=>"Administrador")
     rol2=Rol.create(:nombre=>"Agente")
     rol3=Rol.create(:nombre=>"Encargado")
     
     

     usuario1=Usuario.new(:login => 'administrador', :email => 'admin@example.com', :password => 'administrador', :password_confirmation => 'administrador', :nombre => "Genáro Martinez")
     usuario1.rol=rol1
     
     
     usuario2=Usuario.new(:login => 'agente1', :email => 'agente@example.com', :password => 'agente1', :password_confirmation => 'agente1', :nombre => "Apodaca Juárez")
     usuario2.rol=rol2
     usuario2.save!
     
     usuario3=Usuario.new(:login => 'encargado1', :email => 'encargado@example.com', :password => 'encargado1', :password_confirmation => 'encargado1', :nombre => "Cleotistido Paez")
     usuario3.rol=rol3
     
     usuario1.save
     usuario2.save
     usuario3.save
  end

  def self.down
  end
end
