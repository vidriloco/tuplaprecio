class PaqueteClon < ActiveRecord::Base
  has_one   :log, :as => :recurso
  
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
  
  def servicios_incluidos
    servicios = String.new
    
    servicios += "#{internet}, " if !internet.blank?
    servicios += "#{telefonia}, " if !telefonia.blank?
    servicios += "#{television}, " if !television.blank?
    servicios.chop.chop
  end
end