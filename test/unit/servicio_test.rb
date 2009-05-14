require 'test_helper'

class ServicioTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "creacion de servicio correctamente" do
    servicio = Servicio.build
    assert servicio.valid?, "Instancia servicio no válida:\n#{servicio.to_yaml}"
  end
  
  test "metodo de asociacion de un servicio con una opcion o modalidad" do
    servicio = Servicio.build
    concepto = Concepto.build
    servicio.pon_concepto(concepto)
    assert_equal servicio.concepto, concepto
  end

end
