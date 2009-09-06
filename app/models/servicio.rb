class Servicio < ActiveRecord::Base
  include Compartido
  include LogMethods
  
  belongs_to :plaza
  belongs_to :metasubservicio
  has_many   :conceptos, :validate => false, :dependent => :destroy
  has_many   :logs, :as => :recurso  
     
  validates_presence_of :metasubservicio_id, :message => "no puede ir en blanco"
  validates_uniqueness_of :metasubservicio_id, :scope => :plaza_id
  validate :atributos_de_conceptos
  
  # Necesario para poder obtener CSVs de éste modelo
  acts_as_reportable
    
  # Método auxiliar en controlador servicios acción edit
  # Trata el caso en el que se hayan añadido más metaconceptos al metaservicio.
  # Averigua cuál es la diferencia entre los metaconceptos del metaservicio y la instancia del servicio ligado al metaservicio,
  # después actualiza los conceptos del servicio.
  def actualiza_conceptos
    metaservicio = self.metasubservicio.metaservicio
    metaconceptos= metaservicio.metaconceptos
    conceptos = self.conceptos
    if conceptos.size < metaconceptos.size
      metaconceptos_agregables=metaconceptos.last(metaconceptos.size-conceptos.size) 
      metaconceptos_agregables.each do |mc|
        concepto = Concepto.create(:metaconcepto => mc)
        self.conceptos << concepto
      end
    end
    return metaservicio.metasubservicios
  end  
    
  # Metodo auxiliar en controlador servicios acción update para tratar con los conceptos asociados  
  def adjunta_conceptos(hash)
    return false if hash.nil?
    
    hash.each_key { |key| self.conceptos.find(key).update_attributes(hash[key]) } 
  end
    
  # Atributos de éste modelo presentes al momento de desplegar instancias de éste modelo  
  def self.atributos
    ["plaza_", "tipo_de_servicio", "nombre_del_servicio", "número_de_conceptos"]
  end  
  
  def self.atributos_agente
    ["tipo_de_servicio", "nombre_del_servicio"]
  end
  
  # Atributos cuyos valores relativos a cada instancia de éste modelo serán traducidos a código ruby en un archivo para exportar como copia de seguridad
  def self.atributos_exportables
    []
  end
  
  def self.cambia(atributo)
    atributo.humanize
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
    disponibles = conceptos.inject(0) {|i,c| i += 1 if c.disponible; i }
    return "'0 conceptos'" if numero==0
    
    if disponibles==1
      no_disponibles = "#{disponibles} disponible"
    else
      no_disponibles = "#{disponibles} disponibles"
    end
    
    if numero==1
      no_conceptos = "#{numero} concepto (#{no_disponibles})" 
    else
      no_conceptos = "#{numero} conceptos (#{no_disponibles})"
    end
    "link_to_remote '#{no_conceptos}', :url => {:action => 'detalles_asociados', :id => #{id}, :accion => 'mostrar' }"
  end
  
  def expose
    ["Servicio :", "#{detalles_}"]
  end
  
  def self.busca(algo)
    resultados = ["Servicio"]
    fragmento = "metasubservicios.nombre ILIKE ? OR metaservicios.nombre ILIKE ?"
    
    arreglo_de_condiciones = []
    sql_statements = String.new
    algo.each do |a|
      sql_statements << fragmento + " OR "
      arreglo_de_condiciones += ["%#{a}%"]*2
    end
    sql_statements = sql_statements[0, sql_statements.length - 4]
    arreglo_de_condiciones.insert(0, sql_statements)
    resultados +=  self.find(:all, :include => [:plaza,{:metasubservicio => :metaservicio}], :conditions => arreglo_de_condiciones) 
    
    resultados
  end
  
  def conceptos_asociados_en_orden
    Concepto.find :all, :select => "id, concepto, costo, disponible, valor", :conditions => {:servicio_id => id}, :include => 'metaconcepto', :order => "metaconceptos.posicion ASC"
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
