class Migrador
  
  def initialize
    @escritas=Array.new
    @marcados_para_guardar = Hash.new
  end
  
  def registra_tabla(tabla)
    @escritas << tabla
  end
  
  def tabla_ya_escrita?(tabla)
    !@escritas.index(tabla).nil?
  end
  
  def agrega_marcado(clase, numero)
    if @marcados_para_guardar.has_key?(clase)
      if @marcados_para_guardar[clase].index(numero).nil?
        @marcados_para_guardar[clase] << numero
        return true
      else
        return false
      end
    else
      @marcados_para_guardar[clase] = [numero]
      return true
    end
  end
  
end
