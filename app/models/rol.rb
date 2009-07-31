class Rol < ActiveRecord::Base
  include Compartido
  
  acts_as_reportable
  
  has_many :usuarios
  
  attributes_to_serialize :nombre, :associated => [:usuarios]
  
  validates_presence_of :nombre
  validates_uniqueness_of :nombre
  
  def self.atributos
    ["nombre", "usuarios_"]
  end
  
  def self.atributos_exportables
    [:nombre]
  end
  
  def usuarios_
    usuarios_nombres=usuarios.inject("") do |cdna, usuario|
      cdna<<"#{usuario.login}, "
      cdna
    end
    return "-" if usuarios_nombres.blank?
    usuarios_nombres.chop.chop
  end
  
  def self.limpia_todos_excepto(este)
    Rol.all.each do |r|
      r.delete unless r.eql?(este)
    end
  end
end
