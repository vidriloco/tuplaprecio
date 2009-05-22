class AddTestModels < ActiveRecord::Migration
  def self.up
     categoria1=Categoria.create(:nombre => "Internet")
     categoria2=Categoria.create(:nombre => "ALO 100")
     categoria3=Categoria.create(:nombre => "Premium")
     categoria4=Categoria.create(:nombre => "ALO 150")

     concepto_internet1 =Concepto.create(:nombre => "Contratación Cliente Activo")
     concepto_internet2 =Concepto.create(:nombre => "Contratación Cliente Nuevo")
     concepto_internet3 =Concepto.create(:nombre => "Tarjeta de Red") 
     concepto_internet4 =Concepto.create(:nombre => "Renta Mensual: 128 kbps")
     concepto_internet5 =Concepto.create(:nombre => "Renta Mensual: 512 kbps")
     concepto_internet6 =Concepto.create(:nombre => "Renta Mensual: 1 mbps")
     concepto_internet7 =Concepto.create(:nombre => "Cuentas de correo")
     concepto_internet8 =Concepto.create(:nombre => "Instalación Computadora Adicional")
     concepto_internet9 =Concepto.create(:nombre => "Cambio de ubicación")
     concepto_internet10 =Concepto.create(:nombre => "Cambio de velocidades")
     concepto_internet11 =Concepto.create(:nombre => "Cambio de Domicilio")
     concepto_internet12 =Concepto.create(:nombre => "Cambio de Cable")
     concepto_internet13 =Concepto.create(:nombre => "Metro cable excedente")
     concepto_internet14 =Concepto.create(:nombre => "Visita soporte técnico")
     concepto_internet15 =Concepto.create(:nombre => "Reconexión")
     
     
     
     
     
     
     
     
     concepto2 =Concepto.create(:nombre => "TV Adicional")


     concepto_premium1 =Concepto.create(:nombre => "HBO Pack 3")
     concepto_premium2 =Concepto.create(:nombre => "HBO Max")     
     concepto_premium3 =Concepto.create(:nombre => "Venus")     
     concepto_premium4 =Concepto.create(:nombre => "Play Boy-Venus")     
     
     [1,2,3,4].each do |n|
       eval("concepto_premium#{n}.agrega_nueva_categoria(categoria3)")
     end

     [1,2,3,4,5,6,7,8,9,10,11,12,13,14].each do |n|
       eval("concepto_internet#{n}.agrega_nueva_categoria(categoria1)")
     end

     servicio1 = Servicio.create(:detalles => "Navegación para principiantes")
     servicio1.pon_concepto concepto_internet4
     servicio1.pon_categoria categoria1
     servicio1.save!
     
     servicio2 = Servicio.create(:detalles => "HBO Pack con tres canales")
     servicio2.pon_concepto concepto_premium2
     servicio2.pon_categoria categoria3
     servicio2.save!
     

     servicio3 = Servicio.create(:detalles => "Navegación para intermedios")
     servicio3.pon_concepto concepto_internet5
     servicio3.pon_categoria categoria1
     servicio3.save!
     
     servicio4 = Servicio.create(:detalles => "Navegación para avanzados")
     servicio4.pon_concepto concepto_internet6
     servicio4.pon_categoria categoria1
     servicio4.save!
     
     #computadora adicional
     servicio5 = Servicio.create(:detalles => "")
     servicio5.pon_concepto concepto_internet8
     servicio5.pon_categoria categoria1
     servicio5.save!
     
     servicio6 = Servicio.create(:detalles => "Tarjeta de red ethernet")
     servicio6.pon_concepto concepto_internet3
     servicio6.pon_categoria categoria1
     servicio6.save! 
     
     servicio7 = Servicio.create(:detalles => "Venus")
     servicio7.pon_concepto concepto_premium3
     servicio7.pon_categoria categoria3
     servicio7.save!
     
     especializado1 = Especializado.create(:activo => true, :costo => 120)
     especializado1.servicio = servicio2
     especializado2 = Especializado.create(:activo => true, :costo => 80)
     especializado2.servicio = servicio3
     especializado3 = Especializado.create(:activo => true, :costo => 160)
     especializado3.servicio = servicio4
     
     incorporado1 = Incorporado.create(:costo => 100, :detalles => "")
     incorporado1.servicio = servicio1
     incorporado2 = Incorporado.create(:costo => 60, :detalles => "Disponible en el paquete de canales de películas")
     incorporado2.servicio = servicio2
     incorporado3 = Incorporado.create(:costo => 80, :detalles => "Tarjeta Broadcom BCM4306")
     incorporado3.servicio = servicio6
     incorporado4 = Incorporado.create(:costo => 50, :detalles => "")
     incorporado4.servicio = servicio7

     
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
     
     plaza2.agrega_nuevo_especializado especializado1
     plaza1.agrega_nuevo_especializado especializado2
     plaza1.agrega_nuevo_especializado especializado3
     
     especializado1.plaza = plaza1
     especializado2.plaza = plaza2
     especializado3.plaza = plaza1
     
     estado1.agrega_nueva_plaza plaza1
     estado1.agrega_nueva_plaza plaza2
     estado2.agrega_nueva_plaza plaza3
     
     paquete1 = Paquete.create(:nombre => 'Internet básico en Tepejí del Río')
     paquete1.agrega_nuevo_incorporado incorporado1
     paquete1.agrega_nuevo_incorporado incorporado3
     
     paquete2 = Paquete.create(:nombre => 'Paquete de películas Tepejí del Rio')
     paquete2.agrega_nuevo_incorporado incorporado2
     paquete2.agrega_nuevo_incorporado incorporado4
     
     plaza2.agrega_nuevo_paquete paquete1
     plaza2.agrega_nuevo_paquete paquete2
     
     
     administracion=Administracion.create
     administracion.agrega_nuevo_usuario usuario1
     administracion.nivel_alto="Administrador"
     administracion.nivel_medio="Encargado"
     administracion.nivel_bajo="Agente"
     administracion.save!
     plaza1.agrega_nuevo_usuario usuario3
  end

  def self.down
  end
end
