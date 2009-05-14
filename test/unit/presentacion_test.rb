require 'test_helper'

class PresentacionTest < ActiveSupport::TestCase
  
  test "obtener las presentaciones que son compartidas entre varias plazas" do
    # p1 es compartida entre plaza 1 y plaza 2
    # p2 no es compartida entre ninguna plaza, y esta disponible solo en la plaza 2
    p1 = Presentacion.build
    p2 = Presentacion.build :combo => false
    pl1 = Plaza.build
    pl2 = Plaza.build
    ["p1", "p2", "pl1", "pl2"].each do |instancia|
      eval "#{instancia}.save!"
    end 
    pl1.presentaciones << p1
    pl2.presentaciones << p1
    pl2.presentaciones << p2
    p_compartidas=Presentacion.compartidas
    
    assert_equal 1, p_compartidas.length
    assert_equal p_compartidas[0], p1
  end
  
  test "metodo de asociacion entre una presentacion y uno o más servicios" do
    presentacion = Presentacion.build :combo => false
    servicio = Servicio.build :nombre => "Internet"
    presentacion.agrega_nuevo_servicio(servicio)
    
    assert_equal presentacion.servicios[0], servicio
    assert !presentacion.combo
  end
  
  test "metodo de asociacion entre una presentacion y uno o más servicios con combo si no es solo uno" do
    presentacion = Presentacion.build :combo => false
    presentacion.agrega_nuevo_servicio(Servicio.build(:nombre => "Internet"))
    presentacion.agrega_nuevo_servicio(Servicio.build(:nombre => "Television"))

    assert_equal presentacion.servicios.length, 2
    assert presentacion.combo
  end
  
  test "actualizar un servicio asociado a una presentacion refleja el cambio en su tupla de la tabla de servicios" do
    # ésto se logra gracias al autosave definido en la relacion entre presentacion y servicio en el modelo plaza
    presentacion = Presentacion.build
    servicio = Servicio.build 
    servicio.save!
    presentacion.agrega_nuevo_servicio servicio
    assert_equal presentacion.servicios[0], Servicio.find(:first)
    presentacion.servicios[0].nombre = "Internet"
    presentacion.save!
    assert_equal "Internet", Servicio.find(:first).nombre
    assert_equal presentacion.servicios[0], Servicio.find(:first)
  end
  
  test "eliminar un servicio de la presentacion no lo elimina de su tabla de servicios" do
    p = Presentacion.build
    s = Servicio.build
    s.save!
    p.agrega_nuevo_servicio s
    assert !Presentacion.find(:all)[0].servicios.nil?
    assert_equal s, Servicio.find(:first)
    p.servicios.delete s
    assert_equal p.servicios, []
    assert_equal s, Servicio.find(:first)
  end

  
end
