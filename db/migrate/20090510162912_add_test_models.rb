class AddTestModels < ActiveRecord::Migration
  def self.up
     rol1=Rol.create(:nombre=>"Administrador")
     rol2=Rol.create(:nombre=>"Agente")
     rol3=Rol.create(:nombre=>"Encargado")
     
     

     usuario1=Usuario.create(:login => 'administrador', :email => 'admin@example.com', :password => 'administrador', :password_confirmation => 'administrador', :nombre => "Genáro Martinez")
     usuario1.rol=rol1
     
     usuario2=Usuario.create(:login => 'agente1', :email => 'agente@example.com', :password => 'agente1', :password_confirmation => 'agente1', :nombre => "Apodaca Juárez")
     usuario2.rol=rol2
     usuario2.save!
     
     usuario3=Usuario.create(:login => 'encargado1', :email => 'encargado@example.com', :password => 'encargado1', :password_confirmation => 'encargado1', :nombre => "Marco Antonio Reyes")
     usuario3.rol=rol3
     
     
     
     plaza1 = Plaza.create :nombre => 'San Juan del Río'
     plaza2 = Plaza.create :nombre => 'Tepejí del Río'
     plaza3 = Plaza.create :nombre => 'Soledad de Graciano'
     estado1 = Estado.create :nombre => 'Querétaro'
     estado2 = Estado.create :nombre => 'San Luis Potosí'
    
     
     
     estado1.agrega_nueva_plaza plaza1
     estado1.agrega_nueva_plaza plaza2
     estado2.agrega_nueva_plaza plaza3
     
     
     administracion=Administracion.create
     administracion.agrega_nuevo_usuario usuario1
     administracion.nivel_alto="Administrador"
     administracion.nivel_medio="Encargado"
     administracion.nivel_bajo="Agente"
     administracion.save!
     plaza1.usuarios << usuario3
     plaza1.save
     
     #Migrando datos de metaservicios, y metasubservicios junto con metaconceptos
     
     
     # Metaservicio: Compartidos
     Metaconcepto.create :nombre => "Contratación cliente Nuevo", :tipo => "A"
     Metaconcepto.create :nombre => "Contratación cliente Activo", :tipo => "A"
     Metaconcepto.create :nombre => "Renta Mensual", :tipo => "A"
     Metaconcepto.create :nombre => "Cambio de ubicación", :tipo => "A"
     Metaconcepto.create :nombre => "Cambio de domicilio", :tipo => "A"
     Metaconcepto.create :nombre => "Metro de cable excedente", :tipo => "A"
     Metaconcepto.create :nombre => "Reconexión", :tipo => "A"
     Metaconcepto.create :nombre => "Cambio de cable", :tipo => "A"
     
     # Metaservicio: Televisión
     Metaconcepto.create :nombre => "TV's incluídas al momento de la instalación", :tipo => "B"
     Metaconcepto.create :nombre => "TV Adicional (instalación)", :tipo => "A"
     Metaconcepto.create :nombre => "TV Adicional (renta)", :tipo => "A"

     # Metaservicio: Premium
     Metaconcepto.create :nombre => "Película Familiar (PPV)", :tipo => "A"
     Metaconcepto.create :nombre => "Película Adultos (PPV)", :tipo => "A"
     
     # Metaservicio: Internet
     Metaconcepto.create :nombre => "PC's incluídas al momento de la instalación", :tipo => "B"
     Metaconcepto.create :nombre => "Computadora Adicional (instalación)", :tipo => "A"
     Metaconcepto.create :nombre => "Cambio de velocidades", :tipo => "A"
     Metaconcepto.create :nombre => "Visita de soporte técnico", :tipo => "A"
     
     # Metaservicio: Premium
     Metaconcepto.create :nombre => "Líneas telefónicas", :tipo => "B"
     Metaconcepto.create :nombre => "Soluciones Cablecom", :tipo => "A"
     Metaconcepto.create :nombre => "Instalación de extensión telefónica", :tipo => "A"
     Metaconcepto.create :nombre => "Cambio de paquete", :tipo => "A"
     
     Metaservicio.create :nombre => "Internet"
     Metaservicio.create :nombre => "Televisión"
     Metaservicio.create :nombre => "Telefonía"
     Metaservicio.create :nombre => "Premium"
     
     
  end

  def self.down
  end
end
