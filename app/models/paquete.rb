class Paquete < ActiveRecord::Base
  include Compartido
  
  acts_as_reportable
  
  belongs_to :plaza
  belongs_to :zona
  has_many   :logs, :as => :recurso
        
  validates_presence_of :zona, :costo_1_10, :costo_11_31, :costo_real, :ahorro, :message => "no puede ser vacío"
  validates_numericality_of :costo_1_10, :costo_11_31, :costo_real, :ahorro, :message => "debe ser numérico"
  
  before_validation do |paquete|
    cuenta=0
    
    cuenta+=1 if !paquete.internet.blank?
    cuenta+=1 if !paquete.telefonia.blank?
    cuenta+=1 if !paquete.television.blank?
    
    paquete.numero_de_servicios=cuenta
  end
  
  validates_numericality_of :numero_de_servicios, :greater_than => 1
  
  def self.atributos
    ["tipo_de_paquete", "zona_", "servicios_incluídos", "costo_primer_mitad_de_mes", "costo_segunda_mitad_de_mes", "costo_real_", "ahorro_"]
  end
  
  def self.cambia(atributo)
    dicc = {'costo_primer_mitad_de_mes' => 'Costo (1 al día 10)', 'costo_segunda_mitad_de_mes' => 'Costo (11 al fin de mes)'}
    return dicc[atributo] unless dicc[atributo].nil?
    atributo.humanize
  end
  
  def self.atributos_exportables
    [:costo_1_10, :costo_11_31, :costo_real, :ahorro, :numero_de_servicios, :television, :telefonia, :internet]
  end
  
  def self.traduce(atributo)
    []
  end
  
  def tipo_de_paquete
    (numero_de_servicios > 2) ? "Triple Play" : "Doble Play"
  end
  
  def servicios_incluídos
    servicios = String.new
    
    servicios += "#{internet}, " if !internet.blank?
    servicios += "#{telefonia}, " if !telefonia.blank?
    servicios += "#{television}, " if !television.blank?
    servicios.chop.chop
  end
  
  def zona_
    return zona.nombre unless zona.nil?
    "No asignada aún"
  end
  
  def costo_primer_mitad_de_mes
    return "$ #{costo_1_10.to_s(2)}"
  end
  
  def costo_segunda_mitad_de_mes
    return "$ #{costo_11_31.to_s(2)}"
  end
  
  def costo_real_
    return "$ #{costo_real.to_s(2)}"
  end
  
  def ahorro_
    return "$ #{ahorro.to_s(2)}"
  end
  
  def self.busca(algo)
    resultados = ["Paquete"]
    
    sentencia_no_num = "internet ILIKE ? OR telefonia ILIKE ? OR television ILIKE ?"
    sentencia_num = "costo_1_10 = ? OR costo_11_31 = ? OR costo_real = ? OR ahorro = ?"
    
    arreglo_de_condiciones = []
    sql_statements = String.new
    algo.each do |a|
      if a.numeric?
        sql_statements << sentencia_num + " OR " 
        arreglo_de_condiciones += ["#{a}"]*4
        
        sql_statements << sentencia_no_num + " OR " 
        arreglo_de_condiciones += ["%#{a}%"]*3
      else
        sql_statements << sentencia_no_num + " OR "
        arreglo_de_condiciones += ["%#{a}%"]*3
      end
    end
    sql_statements = sql_statements[0, sql_statements.length - 4]
    arreglo_de_condiciones.insert(0, sql_statements)
    resultados +=  self.find(:all, :conditions => arreglo_de_condiciones) 

    resultados
  end
  
  def expose
    ["Paquete :", "#{nombre}"]
  end
  
  
end
