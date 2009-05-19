# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def modelo_info(modelo, numero=nil)
    cuenta = numero.nil? ? modelo.capitalize.constantize.count : numero
    if cuenta == 1
      out = modelo.capitalize
    else
      out = modelo.capitalize.pluralize
    end
    return cuenta, out
  end
  
  def busca_nivel_de(rol)
    admin=Administracion.first
    admin.nivel_de(rol)
  end
  
  def genero_de(palabra_a_prueba, palabra)
    nuevo = palabra

    if palabra_a_prueba.last.eql? "a"
      last = palabra.last
      nuevo = palabra.chomp(last)+"a"
    end
    nuevo
  end
  
  def logged_in_as
    return "<p><b>No logeado</b>" if session[:usuario_id].nil?
    "<p>#{Usuario.salida_usuario(session[:usuario_id])} | #{link_to 'Cerrar Sesión', :controller => :sesiones, :action => :destroy}</p></p>"
  end
  
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
  
  def cardinaliza(cadena, hash)
    if hash[cadena].keys.length > 1
      cadena.pluralize
    else
      cadena
    end
  end
  
  # FINAL
  
  def genera_atributos_faltantes_forma_para(objeto, f={})
     if objeto.instance_of? Plaza
         out1, out2 = String.new, String.new
       if logged_in_on?("nivel 1")
         out1="<p>
           #{f.label :estado} <br />
           #{f.select :estado_id, lista_hash_objetos_de_modelo("estado")}
         </p>"
         out2="<p>Usuarios</p>
         #{ genera_checkboxes_para("usuario", objeto) }"
       end
        
        para_todos="<p>Paquetes</p>
        #{ genera_checkboxes_para("paquete", objeto) }
        
        <p>Servicios Especializables</p>
        #{ genera_checkboxes_para("especializado", objeto) }
        "
      
        return out1+para_todos+out2
     elsif objeto.instance_of? Servicio
       
       "#{f.label :categoría} <br />
         <p>
             #{f.select :categoria_id, lista_hash_objetos_de_modelo("categoria"), {}, :onchange => remote_function(:url => { :controller => :servicios, 
             :action => :update_conceptos}, :with => "'categoria_servicio='+this.options[this.selectedIndex].value"), :method => :get}
         </p>
        <br/>  
        #{f.label :concepto} <br>
        <p id='concepto_changer'>
            #{ render :partial => 'servicios/concepto_form', :locals => {:f => f, :conceptos => nil}}
        </p>
        <br/>
        #{f.label :detalles} <br/>
        <p>
            #{f.text_area :detalles, :cols => 50, :rows => 5} 
        </p>
        <br/>

        "
     elsif objeto.instance_of? Concepto
       "<p><b>Categorias</b></p>#{ genera_checkboxes_para("categoria", objeto) }"
     end
   end
  
  def genera_forma_para(modelo,f)
      "<p>#{ f.select modelo.pluralize.to_sym, lista_hash_objetos_de_modelo(modelo) }</p>"
  end
  
  # Genera check_box_tag's para "modelo" con datos de "objeto"
  def genera_checkboxes_para(modelo, objeto=nil)
    # Cadena de salida
    out = String.new
    if modelo.eql? "usuario"
      # Arreglo con el id de los usuarios relacionados a "objeto"
      u_ids=objeto.ids_of(:usuarios)
      modelo.capitalize.constantize.all.each do |instancia|
        encargado_en=instancia.responsable_de
        if instancia.responsable_de.eql? 'Administracion'
          encargado_en="Administración"
        end
        estado_seleccion=!u_ids.index(instancia.id).nil?
        out+="<p class='inlined'><i>#{encargado_en}</i></p><p class='inlined'>#{instancia.login}</p> #{ check_box_tag "#{modelo.pluralize}[]", instancia.id, estado_seleccion}<br/>"
      end
    elsif modelo.eql? "servicio"
      p_ids=objeto.ids_of(:servicios)
      modelo.capitalize.constantize.all.each do |instancia|
        unless instancia.categoria.nil?
          estado_seleccion=!p_ids.index(instancia.id).nil?
          out+="<p>#{instancia.concepto.nombre} <b>#{instancia.categoria.nombre}</b> #{ check_box_tag "#{modelo.pluralize}[]", instancia.id, estado_seleccion}</p>"
        end
      end
    elsif modelo.eql? "incorporado"
      p_ids=objeto.ids_of(:incorporados)
      modelo.capitalize.constantize.all.each do |instancia|
        estado_seleccion=!p_ids.index(instancia.id).nil?
        # Verifica si éste incorporado ya está asociado a un paquete. 
        estado_asignacion= instancia.paquete.nil? ? "<i>(Libre)</i>" : "<i>(Asignado)</i>"
        out+="<p> #{estado_asignacion} <b>#{instancia.servicio.categoria.nombre}</b>::#{instancia.servicio.concepto.nombre} - #{instancia.costo_} #{ check_box_tag "#{modelo.pluralize}[]", instancia.id, estado_seleccion}</p>"
      end  
    elsif modelo.eql? "especializado"
      p_ids=objeto.ids_of(:especializados)
      modelo.capitalize.constantize.all.each do |instancia|
        estado_seleccion=!p_ids.index(instancia.id).nil?
        # Verifica si éste incorporado ya está asociado a un paquete. 
        estado_asignacion= instancia.plaza.nil? ? "<i>(Libre)</i>" : "<i>(Asignado)</i>"
        out+="<p> #{estado_asignacion} <b>#{instancia.servicio.categoria.nombre}</b>::#{instancia.servicio.concepto.nombre} - #{instancia.costo_} #{ check_box_tag "#{modelo.pluralize}[]", instancia.id, estado_seleccion}</p>"
      end
    elsif modelo.eql? "paquete"
      # Arreglo con el id de las paquetes relacionados a "objeto"
      p_ids=objeto.ids_of(:paquetes)
      modelo.capitalize.constantize.all.each do |instancia|
        estado_seleccion=!p_ids.index(instancia.id).nil?
        out+="<p><b>#{instancia.nombre}</b> #{instancia.listado_de_servicios_incorporados} #{ check_box_tag "#{modelo.pluralize}[]", instancia.id, estado_seleccion}</p>"
      end
    elsif modelo.eql? "categoria"
      c_ids=objeto.ids_of(:categorias)
      
      modelo.capitalize.constantize.all.each do |instancia|
        estado_seleccion=!c_ids.index(instancia.id).nil?
        
        out+="<p>#{instancia.nombre} #{ check_box_tag "#{modelo.pluralize}[]", instancia.id, estado_seleccion}</p>"
      end
    end
    out
  end
  
  def genera_roundboxes_para(modelo)
    out = String.new
    if modelo.eql? "servicio"
      modelo.capitalize.constantize.all.each do |instancia|
        unless instancia.categoria.nil?
          out+="<p>#{instancia.concepto.nombre} <b>#{instancia.categoria.nombre}</b> #{ radio_button_tag "#{modelo.pluralize}[]", instancia.id, false}</p>"
        end
      end
    end
    out
  end
  
  # Verifica el nivel del usuario que está actualmente logeado
  def logged_in_on?(args)
    return false if session[:usuario_id].nil?
    
    usuario=Usuario.find(session[:usuario_id])      
    admin=Administracion.first
  
    if args.instance_of? Array
      if args.index(admin.nivel_de(usuario.rol.nombre)).nil?
        return false
      end
    else
      unless args.eql?(admin.nivel_de(usuario.rol.nombre))
        return false
      end
    end
    true
  end
  

end
