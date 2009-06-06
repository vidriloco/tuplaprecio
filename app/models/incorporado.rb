class Incorporado < ActiveRecord::Base
  include Compartido
  belongs_to :paquete
  belongs_to :servicio
  
  attributes_to_serialize :pertenece_a_paquete, :categoria, :concepto, :detalles_del_servicio, :detalles_en_paquete, :costo_, :vigencia
  remap_names 'Incorporado' => 'Servicio'
    
  validates_presence_of :costo, :message => "no puede ir vacío"
  validates_numericality_of :costo, :message => "debe ser un valor numérico"
  
  DURACION_PROMOCION_NIL="No especificada"
  
  def costo_
    return "$ #{self.costo} pesos"
  end
  
  def vigencia
    return DURACION_PROMOCION_NIL if self.vigente_hasta.nil? and self.vigente_desde.nil?
    "Vigente desde: <b>#{self.vigente_desde.to_s}</b> hasta: <b>#{self.vigente_hasta.to_s}</b>" 
  end
  
  def pertenece_a_paquete
    return "Aún no asignado a paquete" if self.paquete.nil?
    return self.paquete.nombre
  end
  
  def detalles_en_paquete
    return self.detalles
  end
  
  # Devuelve el nombre del concepto del servicio incorporado.
  def concepto
    self.servicio.concepto.nombre unless self.servicio.concepto.nil?
  end
  
  # Devuelve el nombre de la categoria del servicio incorporado.
  def categoria
    self.servicio.categoria.nombre unless self.servicio.categoria.nil?
  end
  
  # Devuelve los detalles referentes al servicio independientemente al paquete
  def detalles_del_servicio
    self.servicio.detalles
  end
  
  def expose
    ["Servicio (en paquete) :", "#{detalles_en_paquete} #{costo_}"]
  end
  
  # Método auxiliar de clase que busca las instancias que cumplen con *algo en alguno de sus atributos
  # éste método hace una distinción entre atributos numéricos (costo) y no numéricos (detalles) según el tipo de *algo
  def self.busca(algo)
 
      array_conditions = Array.new
      array_conditions[0] = String.new
      
      algo.each_with_index do |a, i|
        if a.to_i != 0
          
          array_conditions[0] += (i == algo.length-1) ? "costo = ? ": "costo = ? OR "
          array_conditions << a
        else
          array_conditions[0]+= (i == algo.length-1) ? "detalles LIKE ? ": "detalles LIKE ? OR "
          array_conditions << "%#{a}%"
        end
      end
      logger.info "SQL Query: #{array_conditions}"
      self.find(:all, :conditions => array_conditions)
  end
end
