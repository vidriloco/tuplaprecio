class Incorporado < ActiveRecord::Base
  include Compartido
  belongs_to :paquete
  belongs_to :servicio
  
  attributes_to_serialize :categoria, :concepto, :detalles_del_servicio, :detalles_en_paquete, :costo_, :vigencia
  remap_names 'Incorporado' => 'Servicio'
  
  DURACION_PROMOCION_NIL="No especificada"
  
  def costo_
    return "$ #{self.costo} pesos"
  end
  
  def vigencia
    return DURACION_PROMOCION_NIL if self.vigente_hasta.nil? and self.vigente_desde.nil?
    "Vigente desde el #{self.vigente_desde.to_s(:long)} hasta el #{self.vigente_hasta.to_s(:long)}" 
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
end
