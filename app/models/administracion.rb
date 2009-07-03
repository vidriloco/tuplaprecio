class Administracion < ActiveRecord::Base
  has_many :usuarios, :as => :responsabilidad
  include Compartido
  
  acts_as_reportable  
  
  def agrega_nuevo_usuario(usuario)
    unless self.usuarios.exists? usuario
      self.usuarios << usuario
    end
  end
  
  def self.atributos_exportables
    [:nivel_alto, :nivel_medio, :nivel_bajo]
  end
  
  def eliminar_usuario(usuario)
    self.listado_de_usuarios.delete(usuario)
  end
  
  def listado_de_usuarios
    self.usuarios
  end
  
  def self.nivel_de(rol)
    @administracion = self.first
    if  @administracion.nivel_alto.eql? rol
      return "nivel 1"
    elsif  @administracion.nivel_medio.eql? rol
      return "nivel 2"
    elsif  @administracion.nivel_bajo.eql? rol
      return "nivel 3"
    end
  end
  
  def self.busqueda
  end
  
end
