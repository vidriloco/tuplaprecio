class Migrador
  
  def initialize
    @escritas=Array.new
  end
  
  def registra_tabla(tabla)
    @escritas << tabla
  end
  
  def tabla_ya_escrita?(tabla)
    !@escritas.index(tabla).nil?
  end
  
end
