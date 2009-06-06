class Especializado < ActiveRecord::Base
  include Compartido
  belongs_to :servicio
  belongs_to :plaza
  
  # Métodos ( y atributos ) que se imprimirán cada vez que se invoque el método *to_hashed_html heredado de Compartido
  attributes_to_serialize :categoria, :concepto, :detalles_del_servicio, :activo_, :costo_
  remap_names 'Especializado' => 'Servicio'
    
  validates_presence_of :costo, :message => "no puede ir vacío"
  validates_numericality_of :costo, :message => "debe ser un valor numérico"
  
  validates_presence_of :activo, :message => "debe ser 'sí' ó 'no'"
  
  # Devuelve el nombre del concepto del servicio incorporado.
  def concepto
    self.servicio.concepto.nombre
  end
  
  # Devuelve el nombre de la categoria del servicio incorporado.
  def categoria
    self.servicio.categoria.nombre
  end
  
  # Devuelve los detalles referentes al servicio independientemente al paquete
  def detalles_del_servicio
    self.servicio.detalles
  end
  
  # Método que devuelve el estado de actividad del servicio en un formato leíble
  def activo_
    if self.activo
      return "Sí"
    else
      "No"
    end
  end
  
  # Método que devuelve el costo del servicio en un formato leíble
  def costo_
    return "$ #{self.costo} pesos"
  end
  
  # Método que expone el atributo :detalles de éste modelo juntamente con el nombre del modelo
  def expose
    ["Servicio (asignado a plaza) :", "#{detalles_del_servicio} #{costo_}"]
  end
  
  # Método auxiliar de clase que busca las instancias que cumplen con *algo en alguno de sus atributos
  # éste método hace una distinción entre atributos numéricos (costo) y no numéricos según el tipo de *algo
  def self.busca(algo)
      array_conditions = Array.new
      array_conditions[0] = String.new
      
      algo.each_with_index do |a, i|
        array_conditions[0] += (i == algo.length-1) ? "costo = ? ": "costo = ? OR "
        array_conditions << a.to_i
      end
      logger.info "SQL Query: #{array_conditions}"
      self.find(:all, :conditions => array_conditions)
  end
  
end
