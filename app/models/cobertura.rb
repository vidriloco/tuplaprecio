class Cobertura < ActiveRecord::Base
  include Compartido
  include LogMethods
  
  belongs_to :plaza
  
  validates_presence_of :nombre, :colonia, :calle
  validates_numericality_of :numero_de_nodo
  
  # Necesario para poder obtener CSVs de éste modelo
  acts_as_reportable
  
  # Atributos de éste modelo presentes al momento de desplegar instancias de éste modelo
  def self.atributos
    ["nombre", "numero_de_nodo", "colonia", "calle"]
  end
  
  # Atributos cuyos valores relativos a cada instancia de éste modelo serán traducidos a código ruby en un archivo para exportar como copia de seguridad
  def self.atributos_exportables
    [:nombre, :numero_de_nodo, :colonia, :calle]
  end
  
  # Método que genera una versión leíble para el usuario de un atributo del modelo
  def self.cambia(atributo)
    dicc = {'numero_de_nodo' => 'Número de nodo'}
    return dicc[atributo] unless dicc[atributo].nil?
    atributo.humanize
  end
  
  # Implementación de búsqueda para éste modelo
  def self.busca(algo)
    resultados = ["Cobertura"]
    
    sentencia_num = "numero_de_nodo = ?"
    sentencia_no_num = "nombre ILIKE ? OR calle ILIKE ? OR colonia ILIKE ?"
    
    arreglo_de_condiciones = []
    sql_statements = String.new
    algo.each do |a|
      if a.numeric?
        sql_statements << sentencia_num + " OR " 
        arreglo_de_condiciones += ["#{a}"]
        
        sql_statements << sentencia_no_num + " OR " 
        arreglo_de_condiciones += ["%#{a}%"]*3
      else
        sql_statements << sentencia_no_num + " OR "
        arreglo_de_condiciones += ["%#{a}%"]*3
      end
    end
    # Ajuste de tamaño para quitar "OR"
    sql_statements = sql_statements[0, sql_statements.length - 4]
    # Inserción de enunciados SQL de búsqueda al inicio del arreglo de condiciones
    arreglo_de_condiciones.insert(0, sql_statements)
    resultados +=  self.find(:all, :conditions => arreglo_de_condiciones) 

    resultados
  end
end
