require 'test_helper'

class AdministracionTest < ActiveSupport::TestCase
 
  test "usuario agregado a la administracion es un usuario ligado a un modelo tipo administracion" do
     a = Administracion.build
     u = Usuario.build
     u.save!
     a.agrega_nuevo_usuario u
     assert_equal "Administracion", a.usuarios[0].responsabilidad_type
  end
   
end
