class Administracion < ActiveRecord::Base
  has_many :usuarios, :as => :responsabilidad
  include Compartido
  
  attributes_to_serialize :associated => [:usuarios]
  
  def agrega_nuevo_usuario(usuario)
    self.usuarios << usuario
    self.save!
  end
  
  def eliminar_usuario(usuario)
    self.listado_de_usuarios.delete(usuario)
  end
  
  def listado_de_usuarios
    self.usuarios
  end
  
  def nivel_de(rol)
    if self.nivel_alto.eql? rol
      return "nivel 1"
    elsif self.nivel_medio.eql? rol
      return "nivel 2"
    elsif self.nivel_bajo.eql? rol
      return "nivel 3"
    end
  end
  
end
