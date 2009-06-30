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
  
  # Realiza una busqueda con match usando LIKE en la base de datos en el atributo nombre,
  # el cuál varios modelos tienen
  def self.busca(algo)
    resultados = [self.to_s]
    fragmento = "plazas.nombre ILIKE ? OR estados.nombre ILIKE ?"
    if algo.length > 1
      campo="plazas.nombre ILIKE ? OR estados.nombre ILIKE ? OR"
      campo=campo*(algo.length-1) + " #{fragmento}"
      array_condition=[campo]
      algo.each do |a|
        array_condition << ["%#{a}%","%#{a}%"]
      end
      resultados self.find(:all, :include => [:estado], :conditions => array_condition)
    else
      resultados + self.find(:all, :include => [:estado], :conditions => [fragmento, "%#{algo}%", "%#{algo}%"])
    end
  end
  
end
