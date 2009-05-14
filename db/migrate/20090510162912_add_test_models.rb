class AddTestModels < ActiveRecord::Migration
  def self.up
     categoria1=Categoria.create(:nombre => "Internet")
     categoria2=Categoria.create(:nombre => "Telefonía")
     categoria3=Categoria.create(:nombre => "Televisión")
     categoria4=Categoria.create(:nombre => "Televisión de Alta Definición")

     concepto1 =Concepto.create(:nombre => "Contratación Cliente Nuevo")
     concepto2 =Concepto.create(:nombre => "TV Adicional")
     concepto3 =Concepto.create(:nombre => "Tarjeta de Red") 
     concepto4 =Concepto.create(:nombre => "Internet 64kbps")
     concepto5 =Concepto.create(:nombre => "Internet 128kbps")
     concepto6 =Concepto.create(:nombre => "HBO Pack 3")
     concepto7 =Concepto.create(:nombre => "HBO Max")

     concepto1.agrega_nueva_categoria categoria1
     concepto1.agrega_nueva_categoria categoria2
     concepto1.agrega_nueva_categoria categoria3
     concepto1.agrega_nueva_categoria categoria4
     
     concepto2.agrega_nueva_categoria categoria3
     concepto3.agrega_nueva_categoria categoria1
     concepto4.agrega_nueva_categoria categoria1
     concepto7.agrega_nueva_categoria categoria3

     servicio1 = Servicio.create(:detalles => "Navegación para principiantes")
     servicio1.pon_concepto concepto4
     servicio1.pon_categoria categoria1
     servicio1.save!
     
     servicio2 = Servicio.create(:detalles => "Las mejores películas de HBO")
     servicio2.pon_concepto concepto6
     servicio2.pon_categoria categoria3
     servicio2.save!
     

     servicio3 = Servicio.create(:detalles => "De tipo Inalámbrica")
     servicio3.pon_concepto concepto3
     servicio3.pon_categoria categoria1
     servicio3.save!
     
     especializado1 = Especializado.create(:activo => true, :costo => 120)
     especializado1.servicio = servicio2
     especializado2 = Especializado.create(:activo => true, :costo => 80)
     especializado2.servicio = servicio3
     
     incorporado1 = Incorporado.create(:costo => 100, :detalles => "Promoción en paquete")
     incorporado1.servicio = servicio1
     incorporado2 = Incorporado.create(:costo => 60, :detalles => "Disponible en el paquete de canales de películas")
     incorporado2.servicio = servicio2
     incorporado3 = Incorporado.create(:costo => 80, :detalles => "Tarjeta Broadcom BCM4306")
     incorporado3.servicio = servicio3
     
     rol1=Rol.create(:nombre=>"Administrador")
     rol2=Rol.create(:nombre=>"Agente")
     rol3=Rol.create(:nombre=>"Encargado")
     
     

     usuario1=Usuario.create(:login => 'globalc', :email => 'globalc@example.com', :password => 'globalc', :password_confirmation => 'globalc')
     usuario1.rol=rol1
     
     usuario2=Usuario.create(:login => 'globalin', :email => 'globalin@example.com', :password => 'globalc', :password_confirmation => 'globalc')
     usuario2.rol=rol2
     
     usuario3=Usuario.create(:login => 'lacardio', :email => 'lacardio@example.com', :password => 'lacaaat', :password_confirmation => 'lacaaat')
     usuario3.rol=rol3
     
     
     plaza1 = Plaza.create :nombre => 'San Juan del Río'
     plaza2 = Plaza.create :nombre => 'Tepejí del Río'
     plaza3 = Plaza.create :nombre => 'Soledad de Graciano'
     estado1 = Estado.create :nombre => 'Querétaro'
     estado2 = Estado.create :nombre => 'San Luis Potosí'
     
     plaza1.agrega_nuevo_especializado especializado1
     plaza2.agrega_nuevo_especializado especializado2
     
     especializado1.plaza = plaza1
     especializado2.plaza = plaza2
     
     estado1.agrega_nueva_plaza plaza1
     estado1.agrega_nueva_plaza plaza2
     estado2.agrega_nueva_plaza plaza3
     
     paquete1 = Paquete.create(:nombre => 'Internet sin cables')
     paquete1.agrega_nuevo_incorporado incorporado1
     paquete1.agrega_nuevo_incorporado incorporado3
     
     paquete2 = Paquete.create(:nombre => 'Paquete de Canales de Películas')
     paquete2.agrega_nuevo_incorporado incorporado2
     
     plaza1.agrega_nuevo_paquete paquete1
     plaza1.agrega_nuevo_paquete paquete2
     
     
     administracion=Administracion.create
     administracion.agrega_nuevo_usuario usuario1
     administracion.nivel_alto="Administrador"
     administracion.nivel_medio="Encargado"
     administracion.nivel_bajo="Agente"
     administracion.save!
     plaza1.agrega_nuevo_usuario usuario2
     plaza2.agrega_nuevo_usuario usuario3
  end

  def self.down
  end
end
