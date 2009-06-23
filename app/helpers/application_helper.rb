# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Método cuyo primer valor de vuelta es la cuenta actual de instancias de *modelo, y
  # el segundo, el valor pluralizado o no dependiendo del número cuenta
  def modelo_info(modelo, numero=nil)
    cuenta = numero.nil? ? modelo.capitalize.constantize.count : numero
    if cuenta == 1
      out = modelo.capitalize
    else
      out = modelo.capitalize.pluralize
    end
    return cuenta, out
  end
  
  # Método auxiliar para determinar el nivel de un *rol
  def busca_nivel_de(rol)
    Administracion.nivel_de(rol)
  end
  
  # verifica si objeto está presente en el arreglo almacenado en sesion
  def existe_en_sesion(sesion, objeto)
    unless session[sesion].nil?
      return false if session[sesion].index(objeto).nil?
      return true
    end
    false
  end
  
  # Devuelve *palabra en un estado modificado según el genero de *palabra_a_prueba
  def genero_de(palabra_a_prueba, palabra)
    nuevo = palabra

    if palabra_a_prueba.last.eql? "a"
      last = palabra.last
      nuevo = palabra.chomp(last)+"a"
    end
    nuevo
  end
  
  # Devuelve la salida (en HTML) para la barra de navegación superior izquierda
  def logged_in_as
    return "<p><b>No logeado</b>" if current_user.nil?
    "<p>#{Usuario.salida_usuario(current_user)} | #{link_to 'Cerrar Sesión', :controller => :sesiones, :action => :destroy}</p></p>"
  end
  
  # Método auxiliar que genera un diccionario con pares de valores. Utilizado para generar opciones para los select forms.
  # Ejemplo: {1 => pepito, 2 => floripondia}
  def lista_hash_objetos_de_modelo(modelo)
    hash= Hash.new
    return hash if modelo.capitalize.constantize.count == 0
    if modelo.eql? "servicio"
      modelo.capitalize.constantize.all.each do |instancia|
        hash["#{instancia.con_categoria}::#{instancia.con_concepto}"] = instancia.id
      end
    else
      modelo.capitalize.constantize.all.each do |instancia|
        hash[instancia.nombre] = instancia.id unless instancia.nombre.blank?
      end
    end
    hash
  end
  
  # Actua de manera similar al método auxiliar anterior, sólo que en vez de obtener la colección de objetos 
  # desde el modelo en sí (invocando *modelo.all) toma la colección de *collection
  def lista_hash_objetos(collection)
    hash= Hash.new
    return hash if collection.length == 0
    collection.each do |objeto|
      hash[objeto.nombre] = objeto.id unless objeto.nombre.blank?
    end
    hash
  end
  
  # Métodos para desplegar el contenido (en formato html) de un hash generado por el método to_hashed_html que representa 
  # a una instancia de algún modelo juntamente con las relaciones definidas para ese modelo respecto a otros modelos
  # INICIO
  
  # Extrae el html de la instancia origen (desde quién se llamo inicialmente el método: to_hashed_html)
  # En el hash ':origin' apunta a la clase de la instancia de dicho objeto. 
  # Ejemplo:  {:origin => 'Plaza', 'Plaza' => "Html de plaza"}
  def extrae_origen(hash)
    origen = hash[:origin]
    hash.delete :origin
    salida = hash[origen]
    hash.delete origen
    salida
  end
  
  # Busca *cadena en *hash como una llave y si *hash[cadena] es un conjunto, entonces 
  # *cadena es pluralizada y se devuelve dicha modificación
  def cardinaliza(cadena, hash)
    if hash[cadena].keys.length > 1
      cadena.pluralize
    else
      cadena
    end
  end
  
  
  def genera_forma_para(modelo,f)
      "<p>#{ f.select modelo.pluralize.to_sym, lista_hash_objetos_de_modelo(modelo) }</p>"
  end
  
  # Genera check_box_tag's para "modelo" con datos de "objeto"
  def genera_checkboxes_para(modelo, objeto=nil)
    # Cadena de salida
    out = String.new
    if modelo.eql? "categoria"
      c_ids=objeto.ids_of(:categorias)
      
      modelo.capitalize.constantize.all.each do |instancia|
        estado_seleccion=!c_ids.index(instancia.id).nil?
        
        out+="<div class='form_opcion' id='small'>#{ check_box_tag "#{modelo.pluralize}[]", instancia.id, estado_seleccion} #{instancia.nombre} </div>"
      end
    end
    out
  end

  
  # Verifica el nivel del usuario que está actualmente logeado
  def logged_in_on?(args)
    return false if session[:usuario_id].nil?
    
    usuario=Usuario.find(session[:usuario_id])      
  
    if args.instance_of? Array
      if args.index(Administracion.nivel_de(usuario.rol.nombre)).nil?
        return false
      end
    else
      unless args.eql?(Administracion.nivel_de(usuario.rol.nombre))
        return false
      end
    end
    true
  end
  
  # Método auxiliar que excluye a objetos que no son paginables.
  def es_paginable?(objeto)
    return objeto.instance_of?(WillPaginate::Collection)
  end
end
