class Plaza < ActiveRecord::Base
  include Compartido
  
  belongs_to :estado
  has_many :paquetes
  has_many :usuarios, :as => :responsabilidad, :autosave => true, :dependent => :nullify
  has_many :servicios
      
  validates_presence_of :nombre, :message => "no puede ser vacío"
  
  def self.atributos
    ["nombre", "estado_", "usuarios_", "paquetes_", "servicios_"]
  end
  
  def estado_
    estado.nombre
  end
  
  def usuarios_
    usuarios_nombres=usuarios.inject("") do |cdna, usuario|
      cdna<<"#{usuario.login}, "
      cdna
    end
    return "-" if usuarios_nombres.blank?
    usuarios_nombres.chop.chop
  end
  
  def paquetes_
    paquetes.size
  end
  
  def servicios_
    servicios_re = servicios.inject("") do |cdna, servicio|
      cdna << "#{servicio.metasubservicio.nombre}, "
      puts cdna
      cdna
    end
    return "-" if servicios_re.blank?
    servicios_re.chop.chop
  end
  
  def to_label
    "#{nombre}"
  end
  
end
