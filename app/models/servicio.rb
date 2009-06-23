class Servicio < ActiveRecord::Base
  
  belongs_to :plaza
  belongs_to :metasubservicio
  has_many :conceptos, :validate => false
  
  validates_presence_of :metasubservicio_id, :message => "no puede ir en blanco"
  validates_uniqueness_of :metasubservicio_id
  validate :atributos_de_conceptos
    
  def self.atributos
    ["plaza_", "tipo_de_servicio", "nombre_del_servicio", "número_de_conceptos"]
  end  
  
  def self.atributos_agente
    ["tipo_de_servicio", "nombre_del_servicio"]
  end
  
  def self.es_evaluable(atributo)
    hash_atributos={"número_de_conceptos" => true}
    return hash_atributos[atributo]
  end
  
  def plaza_
    plaza.nombre
  end
  
  def tipo_de_servicio
    metasubservicio.metaservicio.nombre
  end
  
  def nombre_del_servicio
    metasubservicio.nombre
  end
  
  def número_de_conceptos
    numero = conceptos.size
    return "'0 conceptos'" if numero==0
    if numero==1
      no_conceptos = "#{numero} concepto" 
    else
      no_conceptos = "#{numero} conceptos"
    end
    "link_to_remote '#{no_conceptos}', :url => {:action => 'detalles_asociados', :id => #{id}, :accion => 'mostrar' }"
  end
  
  def expose
    ["Servicio :", "#{detalles_}"]
  end
  
  def self.busca(algo)
    fragmento = "detalles LIKE ?"
    if algo.length > 1
      campo="detalles LIKE ? OR "
      campo=campo*(algo.length-1) + " #{fragmento}"
      array_condition=[campo]
      algo.each do |a|
        array_condition << "%#{a}%"
      end
      self.find(:all, :conditions => array_condition)
    else
      self.find(:all, :conditions => [fragmento, "%#{algo}%"])
    end
  end
  
  protected
    def atributos_de_conceptos
      conceptos.each do |c|
        unless c.valid?
          c.errors.full_messages.each do |m|
            errors.add(:conceptos, "#{m}")
          end
        end
      end
    end
  
end
