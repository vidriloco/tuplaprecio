class Estado < ActiveRecord::Base
  include Compartido
  
  validates_presence_of :nombre, :message => "no puede ser vacío"
    
  has_many :plazas, :dependent => :destroy
  
  # Necesario para poder obtener CSVs de éste modelo
  acts_as_reportable
    
  def self.atributos
    ["nombre", "plazas_"]
  end
  
  def self.atributos_exportables
    [:nombre]
  end
  
  def agrega_nueva_plaza(plaza)
    unless self.plazas.exists? plaza
      self.plazas << plaza
      self.save!
    end
  end
  
  def to_label
    "#{nombre}"
  end
  
  def plazas_
    plazas_nombres=plazas.inject("") do |cdna, plaza|
      cdna<<"#{plaza.nombre}, "
      cdna
    end
    return "-" if plazas_nombres.blank?
    plazas_nombres.chop.chop
  end
  
  # Realiza una busqueda con match usando LIKE en la base de datos en el atributo nombre,
  # el cuál varios modelos tienen
  def self.busca(algo)
    resultados = [self.to_s]
    fragmento = "nombre ILIKE ?"
    if algo.length > 1
      campo="nombre ILIKE ? OR "
      campo=campo*(algo.length-1) + " #{fragmento}"
      array_condition=[campo]
      algo.each do |a|
        array_condition << "%#{a}%"
      end
       resultados + self.find(:all, :conditions => array_condition)
    else
      resultados + self.find(:all, :conditions => [fragmento, "%#{algo}%"])
    end
  end
  
end
