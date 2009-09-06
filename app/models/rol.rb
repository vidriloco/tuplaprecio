class Rol < ActiveRecord::Base
  include Compartido
  
  has_many :usuarios
  
  attributes_to_serialize :nombre, :associated => [:usuarios]
  
  validates_presence_of :nombre
  validates_uniqueness_of :nombre
  
  # Necesario para poder obtener CSVs de éste modelo
  acts_as_reportable
  
  # Atributos de éste modelo presentes al momento de desplegar instancias de éste modelo
  def self.atributos
    ["nombre", "usuarios_"]
  end
  
  # Atributos cuyos valores relativos a cada instancia de éste modelo serán traducidos a código ruby en un archivo para exportar como copia de seguridad
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
