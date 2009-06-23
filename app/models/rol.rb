class Rol < ActiveRecord::Base
  include Compartido
  
  has_many :usuarios
  
  attributes_to_serialize :nombre, :associated => [:usuarios]
  
  validates_presence_of :nombre, :message => "no puede ser vacío"
  
  def atributos
    ["nombre", "usuarios_"]
  end
  
  def usuarios_
    usuarios_nombres=usuarios.inject("") do |cdna, usuario|
      cdna<<"#{usuario.login}, "
      cdna
    end
    return "-" if usuarios_nombres.blank?
    usuarios_nombres.chop.chop
  end
  
  def self.busqueda 
  end
end
