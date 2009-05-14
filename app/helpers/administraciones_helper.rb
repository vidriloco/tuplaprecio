module AdministracionesHelper
  
  # Desplegar información sobre un servicio
  def excepcion_para_servicios_en_este_nivel(identificador)
     modelo, id = identificador.split('-')
     if modelo.eql? "Servicio"
        servicio=Servicio.find(id)
        return "<br><b>#{servicio.con_concepto}</b>"
     else
        return
     end
  end
  
  def link_eliminar_registro_relacionado(identificador, obj)
     modelo, id = identificador.split('-')
     return "" if modelo.eql?("Usuario")
     return "" if modelo.eql?("Administracion") && session[:usuario_id] == obj.id
     supermodelo = obj.class.to_s
     datos_separacion = {:submodelo => modelo, :id_submodelo => id, :id_supermodelo => obj.id}
     return "#{link_to_remote "Separar", :url => {:controller => supermodelo.pluralize.downcase, 
                                                  :action => :separar_objetos, 
                                                  :identificador => identificador,
                                                  :datos_separacion => datos_separacion }, :confirm => "¿Deseas separar éste registro del que lo contiene?"}"
  end
end
