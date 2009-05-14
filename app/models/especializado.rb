class Especializado < ActiveRecord::Base
  include Compartido
  belongs_to :servicio
  belongs_to :plaza
  
  attributes_to_serialize :categoria, :concepto, :detalles_del_servicio, :activo_, :costo_
  remap_names 'Especializado' => 'Servicio'
  
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
  
  def activo_
    if self.activo
      return "Sí"
    else
      "No"
    end
  end
  
  def costo_
    return "$ #{self.costo} pesos"
  end
  
  
end
