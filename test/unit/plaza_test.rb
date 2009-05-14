require 'test_helper'

class PlazaTest < ActiveSupport::TestCase
  
  #fixtures :plazas
  
  test "debe guardar correctamente una instancia de la clase Plaza" do
    plaza = Plaza.build
    assert plaza.valid?, "Instancia plaza no válida:\n#{plaza.to_yaml}"
  end
  
  test "agrega un tipo de presentación correctamente" do
    plaza = Plaza.build 
    presentacion = Presentacion.build
    plaza.presentaciones << presentacion
    plaza.save!
    assert_equal plaza.presentaciones[0],presentacion
  end
  
  test "prueba del metodo combos" do
    plaza = Plaza.build 
    ["Telefonía", "Television", "Internet"].each do |servicio|
      p = Presentacion.build(:nombre => servicio, :combo => false, :costo => 0)
      plaza.presentaciones << p
    end
    arreglo_combos = ["Dos en Uno", "Tres en Uno", "Promoción Especial"].each do |presentacion|
      p = Presentacion.build(:nombre => presentacion)
      p.save!
      plaza.presentaciones << p
    end
    plaza.save!
    pseudo_combos=plaza.combos
    assert_equal pseudo_combos.length, arreglo_combos.length
    pseudo_combos.each do |p_combo|
      assert_not_nil arreglo_combos.index(p_combo.nombre)
    end
  end
  
  test "plazas con las que una plaza comparte presentaciones" do
    pl1 = Plaza.build
    pl2 = Plaza.build :nombre => "Jalapa"
    pon1 = Presentacion.build :combo => true, :nombre => "Dos en Uno", :costo => 300
    pon1.save!
    pl1.agrega_nueva_presentacion pon1
    pl2.agrega_nueva_presentacion pon1
    hc1 = pl1.presentaciones_que_comparto_con_plazas
    assert_equal pl2, hc1[pon1][0]
    hc2 = pl2.presentaciones_que_comparto_con_plazas
    assert_equal pl1, hc2[pon1][0]
  end
  
  test "compartir presentaciones funciona correctamente" do
    plazaUno = Plaza.build 
    plazaDos = Plaza.build :nombre => "Villahermosa"
    presentacion = Presentacion.build :combo => true, :nombre => "Dos en Uno", :costo => 300
    plazaUno.agrega_nueva_presentacion presentacion
    plazaDos.agrega_nueva_presentacion presentacion
    presentacion_de_Uno = plazaUno.presentaciones.find(:first, :conditions => "nombre = 'Dos en Uno'")
    presentacion_de_Dos = plazaDos.presentaciones.find(:first, :conditions => "nombre = 'Dos en Uno'")
    assert_not_equal presentacion_de_Uno.plaza, presentacion_de_Dos.plaza
  end
  
  # forma no destructiva se refiere a que al eliminar la presentacion de la lista de la plaza ésta no se elimina de
  # la tabla de presentaciones
  test "elimina una presentación existente de la lista de presentaciones de ésta plaza de forma NO destructiva" do
    plaza = Plaza.build
    presentacion = Presentacion.build
    plaza.agrega_nueva_presentacion presentacion
    numero_de_presentaciones = plaza.presentaciones.count
    presentacion = plaza.presentaciones.find :first
    plaza.eliminar_presentacion(presentacion, "ND")
    assert_operator plaza.presentaciones.count, "<", numero_de_presentaciones
    assert_not_nil Presentacion.find(1)
  end
  
  # forma destructiva se refiere a que al eliminar la presentacion de la lista de la plaza ésta se elimina también 
  # de la tabla de presentaciones
  test "elimina una presentación existente de la lista de presentaciones de ésta plaza de forma destructiva" do
    plaza = Plaza.build
    presentacion = Presentacion.build
    plaza.agrega_nueva_presentacion presentacion
    numero_de_presentaciones = plaza.presentaciones.count
    presentacion = plaza.presentaciones.find :first
    plaza.eliminar_presentacion(presentacion)
    assert_operator plaza.presentaciones.count, "<", numero_de_presentaciones
    assert_nil Presentacion.find(:first)
  end
  
  # forma no destructiva se refiere a que al eliminar la presentacion de la lista de la plaza ésta no se elimina de
  # la tabla de presentaciones
  test "NO elimina una presentación existente de la lista de presentaciones de ésta plaza de forma destructiva si otras plazas la utilizan" do
    plaza = Plaza.build
    plaza_dos = Plaza.build
    presentacion = Presentacion.build :nombre => "Internet y Televisión"
    presentacion.save!
    plaza.agrega_nueva_presentacion presentacion
    plaza_dos.agrega_nueva_presentacion presentacion
    numero_de_presentaciones = plaza.presentaciones.count
    presentacion = plaza.presentaciones[0]
    plaza.eliminar_presentacion(presentacion)
    assert_operator plaza.presentaciones.count, "<", numero_de_presentaciones
    assert_not_nil Presentacion.find(:first)
    assert_equal presentacion, Presentacion.find(:first)
    assert_equal plaza_dos.presentaciones[0], Presentacion.find(:first)
    assert_not_equal plaza.presentaciones[0], Presentacion.find(:first)
  end
  
  test "validar que una plaza siempre tenga un nombre" do
    plaza = Plaza.build :nombre => ""
    assert !plaza.valid?
  end
  
  
  test "establece un estado para la plaza de manera unica" do
   plaza = Plaza.build
   estadoUno = Estado.build
   plaza.estado = estadoUno
   plaza.save!
   assert_equal estadoUno, plaza.estado
   estadoDos = Estado.build
   plaza.estado = estadoDos
   plaza.save!
   assert_not_equal estadoUno, plaza.estado
  end
  
  test "metodo de ligado entre una plaza y una o mas presentaciones" do
    plaza = Plaza.build
    presentacion = Presentacion.build
    plaza.save!
    plaza.agrega_nueva_presentacion presentacion
    assert_equal presentacion, plaza.presentaciones[0]
    assert_equal presentacion.plazas[0], plaza
  end
  
  test "actualizar una presentacion asociada a una plaza refleja el cambio en su tupla de la tabla de presentaciones" do
    # ésto se logra gracias al autosave definido en la relacion entre presentacion y plaz en el modelo presentacion
    presentacion = Presentacion.build
    plaza = Plaza.build 
    presentacion.save!
    plaza.agrega_nueva_presentacion presentacion
    assert_equal plaza.presentaciones[0], Presentacion.find(:first)
    plaza.presentaciones[0].costo = 1899
    plaza.save!
    assert_equal 1899, Presentacion.find(:first).costo
    assert_equal plaza.presentaciones[0], Presentacion.find(:first)
  end
  
  test "plazas puedan tener varios usuarios" do
    p, usuarios = generico_creacion_y_agregacion_de_usuario
    p.usuarios.each do |usuario|
      assert_not_nil usuarios.index(usuario.nombre) 
    end
  end
  
  test "eliminacion de un usuario de una plaza" do
    p, usuarios = generico_creacion_y_agregacion_de_usuario
    usuario=p.usuarios[0]
    p.eliminar_usuario usuario
    assert_nil p.usuarios.index(usuario)
  end
  
  test "usuario agregado a una plaza es un usuario ligado a un modelo tipo plaza" do
    p = Plaza.build
    u = Usuario.build
    u.save!
    p.agrega_nuevo_usuario u
    assert_equal "Plaza", p.usuarios[0].responsabilidad_type
  end
  
  test "listar los usuarios asignados a una plaza" do
    p, usuarios = generico_creacion_y_agregacion_de_usuario
    p.usuarios.each do |usuario|
      assert_not_nil usuarios.index(usuario.nombre)
    end
  end
  
  private 
  
    def generico_creacion_y_agregacion_de_usuario
      p = Plaza.build
      usuarios=["marco", "luis", "juana"].each do |nombre|
        u = Usuario.build(:nombre => nombre, :login => nombre.capitalize, :email => "#{nombre}@example.com")
        u.save!
        p.agrega_nuevo_usuario u
      end
      return p, usuarios
    end
  
end
