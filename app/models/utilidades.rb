require 'zip/zip'
require 'zip/zipfilesystem'

require 'fastercsv'
require 'migrador'

require "rubygems"

require "pdf/writer"
require 'pdf/simpletable'

class Utilidades
  # Variable de clase con los modelos que se han de exportar a rb, exportar a csv, ó bien purgar.      
  MODELOS = ["Estado", "Zona", "Plaza", "Paquete", "Cobertura",
         "Metaservicio", "Metasubservicio", "Servicio", "Metaconcepto", "Concepto", "Rol", "Usuario"]  
  
  # Método que genera un archivo zip que contiene archivos de tipo CSV con los registros de cada tupla en la BD
  def self.genera_zip(archivo_salida="salida_csv")
    t = Tempfile.new("#{@archivo_salida}")
    
    Zip::ZipOutputStream.open(t.path) do |zipfile|
       
       MODELOS.each do |modelo|
        # Invoca método de ruport para generar una tabla excluyendo los atributos en :except 
        salida = modelo.constantize.report_table(:all, :except => [:updated_at, :created_at]).as(:csv)
        zipfile.put_next_entry("#{modelo}.csv")
        zipfile.print salida
       end
    end
    #Archivo cerrado al final del bloque
    t.path  
  end
  
  # Método que lee un archivo CSV y lo incorpora a la base de datos a través de ActiveRecord.
  # Método NO Funcional para tal objetivo, pues se pierden las referencias entre objetos.
  def self.unzip_archivo(archivo_entrada) 
    
    Zip::ZipFile.open(archivo_entrada.path, Zip::ZipFile::CREATE) do |zipfile|
      MODELOS.each do |modelo|
        cdna = zipfile.read("#{modelo}.csv")
        
        parsed = FasterCSV.parse(cdna) 
        atrs = parsed.delete_at(0)
        parsed.each do |columna|
          hash={}
          atrs.each_with_index do |a,i|
            hash[a] = columna[i]
          end
          @objeto=modelo.constantize.new(hash)
        end
      end
    end
  end
  
  # {:plaza => [:paquete, :servicio], :zona => [:paquete], :servicio => [:concepto], :metasubservicio => [:servicio], 
  #  :metaconcepto => [:concepto], :metaconcepto => [:metaservicio], :estado => [:plaza]} 
  # Método que exporta un conjunto de instancias de modelos relacionados a una representación de dicha relación mediante
  # código ruby, haciéndo uso de ActiveRecord.
  def self.migracion_exporta_rb(modelos_hash=nil)
    
    if modelos_hash.nil?
      modelos_hash = {:plaza => [:paquete, :servicio, :cobertura, :usuario],
                      :rol => [:usuario],
                      :estado => [:plaza], 
                      :zona => [:paquete],
                      :servicio => [:concepto], 
                      :metaconcepto => [:concepto, :metaservicio],
                      :metaservicio => [:metasubservicio],
                      :metasubservicio => [:servicio]} 
    end
    
    migrador=Migrador.new                    
    cadena_guardados=String.new
    
    #funcion para generar codigo ruby de cada tupla en la tabla modelo
    modelo_creator = Proc.new do |modelo|
      puts "Escribiendo: #{modelo}"
      atributos_modelo = modelo.to_s.capitalize.constantize.atributos_exportables
      puts "Con atributos: #{atributos_modelo}"
      cadena_final = String.new
      
      modelo.to_s.capitalize.constantize.all.each do |m|
        hash_cadena=String.new

        atributos_modelo.each do |atr|
          hash_cadena << ":#{atr.to_s} => \"#{m.send(atr)}\", "
        end
        puts "Valores de cadena: #{hash_cadena}"
        unless hash_cadena.blank?
          hash_cadena.chop!.chop!
        end
        cadena_modelo = "#{modelo.to_s.downcase}_#{m.id} = #{modelo.to_s.capitalize}.create(#{hash_cadena})\n"
        migrador.agrega_marcado(modelo.to_s.downcase, m.id) ? (cadena_guardados << "#{modelo.to_s.downcase}_#{m.id}.save\n") : false
        cadena_final << cadena_modelo
        
      end
      cadena_final
    end
    
    #funcion para generar codigo ruby de cada tupla en la tabla modelo
    # segunda pasada en la que se escriben a las instancias asociadas
    liga_modelos = Proc.new do |modelo_has_many, modelo_belongs_to|
      puts "Escribiendo asociado: #{modelo_belongs_to} a: #{modelo_has_many}"
    
      cadena_final = String.new
      
      modelo_belongs_to.to_s.capitalize.constantize.all.each do |m|
        if m.respond_to?(modelo_has_many)
          puts "No plural"
          m_id=m.send(modelo_has_many)
          if m_id != nil
            cadena_modelo = "#{modelo_belongs_to.to_s.downcase}_#{m.id}.#{modelo_has_many} = #{modelo_has_many}_#{m_id.id}\n"
            cadena_final << cadena_modelo
          end
        elsif m.respond_to?(modelo_has_many.to_s.pluralize)
          puts "Plural"
          m_id=m.send(modelo_has_many.to_s.pluralize)
          if !m_id.empty?
            m_id.each do |mid|
              cadena_modelo = "#{modelo_belongs_to.to_s.downcase}_#{m.id}.#{modelo_has_many.to_s.pluralize} << #{modelo_has_many}_#{mid.id}\n"
              cadena_final << cadena_modelo
            end
          end
        end
        if migrador.agrega_marcado(modelo_belongs_to.to_s.downcase, m.id) 
           cadena_guardados << "#{modelo_belongs_to.to_s.downcase}_#{m.id}.save\n"
        end
      end
      
      cadena_final
    end
    puts "Inciando..."
    cadena_de_salida=String.new
    puts "Datos de entrada: #{modelos_hash}"
    # Devuelve la llave que es un modelo en simbolo (ie {:modelo1 => -----} )
    modelos_hash.each_key do |key_modelo|
      puts "Tratando con: #{key_modelo}"
      unless migrador.tabla_ya_escrita?(key_modelo)
        puts "No escrita aún: #{key_modelo}"
        cadena_de_salida << modelo_creator.call(key_modelo)
        migrador.registra_tabla(key_modelo)
      end
    end
        
    modelos_hash.each_pair do |key, value|
      puts "Segunda pasada con: #{key}"
      value.each do |invalue|
        puts "Repasando: #{invalue}"
        unless migrador.tabla_ya_escrita?(invalue)
          cadena_de_salida << modelo_creator.call(invalue)
          migrador.registra_tabla(invalue)
        end
        cadena_de_salida << liga_modelos.call(key, invalue)
      end
    end
    
    t = Tempfile.new("migracion_db_ruby.rb")
    Backup.actualiza_hash(cadena_de_salida+cadena_guardados)
    File.open(t.path, "wb") do |f|
      f.write cadena_de_salida
      f.write cadena_guardados
    end
    t.path
  end
  
  # Método de purga de la base de datos. Excluye de ser eliminado al usuario actual y a su rol asociado.
  def self.limpia_bd(current_user)
    MODELOS.each do |modelo|
      if modelo.eql? "Usuario"
        modelo.capitalize.constantize.limpia_todos_excepto(current_user)
      elsif modelo.eql? "Rol"
        modelo.capitalize.constantize.limpia_todos_excepto(current_user.rol)        
      else
        modelo.capitalize.constantize.destroy_all
      end
    end    
  end
  
  # Método que lee un archivo escrito en código ruby y evalua su contenido.
  # Se espera que tal archivo contenga código relacíonado a registros de una base de datos antigua
  # que se incorporaran a la base de datos actual mediante ActiveRecord.
  def self.migracion_importa_rb(archivo)
    f=File.open(archivo.path)
    datos = f.read
    f.close
    # Verificar si el archivo se mantuvo intacto desde que se generó.
    if Backup.hash_es_el_mismo(datos)
      eval(datos)
      true
    else
      false
    end
  end

  def self.genera_pdf_log(log)
   document = PDF::HTMLDoc.new
   document.set_option :left, '2cm'
   document.set_option :right, '2cm'
   document.set_option :path, "#{RAILS_ROOT}/public/"
   document.set_option :header, "Reporte de modificaciones en sistema de precios de cablecom"
   document.set_option :webpage, true
   document.set_option :footer, "Éste reporte fue obtenido por el administrador del sistema"
   document.set_option :landscape, true
   document << log.toutf_8
   document.generate
  end
  
  # Método que genera un archivo PDF en base a los logs seleccionados, que le son pasados como
  # parámetros a éste método.
  def self.genera_pdf(logs)
    pdf = PDF::Writer.prepress(:top_margin => 150, :bottom_margin => 60)
    
    pdf.open_object do |heading| 
      pdf.save_state 
      
      pdf.select_font "Times-Roman"
      
      pdf.stroke_color! Color::Black 
      pdf.stroke_style! PDF::Writer::StrokeStyle::DEFAULT 
      pdf.image "#{RAILS_ROOT}/public/images/cablecom.jpg", :resize => 0.46
      
      pdf.add_text_wrap(270, pdf.y+25, 400, "<i>Reporte de modificaciones de precios de Cablecom</i>", 15)
      pdf.add_text_wrap(350, pdf.y, 300, "<i>Reporte generado <b>#{I18n.localize(Time.now, :format => :short)}</b></i>", 12)

      pdf.line(pdf.absolute_left_margin, pdf.y-15, pdf.absolute_right_margin, pdf.y-15).stroke 
      
      pdf.restore_state 
      pdf.close_object 
      pdf.add_object(heading, :all_pages) 
    end
    
    pdf.open_object do |footer| 
      pdf.save_state 
      
      pdf.select_font "Times-Roman"
      
      pdf.stroke_color! Color::Black 
      pdf.stroke_style! PDF::Writer::StrokeStyle::DEFAULT 
      
      pdf.line(pdf.absolute_left_margin, pdf.absolute_bottom_margin + 10, pdf.absolute_right_margin, pdf.absolute_bottom_margin + 10).stroke 
      
      pdf.add_text(pdf.absolute_x_middle-145, pdf.absolute_bottom_margin, "<i>Éste Reporte fue obtenido por el Administrador del sistema</i>".toutf_8, 12)

      
      pdf.restore_state 
      pdf.close_object 
      pdf.add_object(footer, :all_pages) 
    end
    
    pdf.select_font "Helvetica"
    
    pdf.text " ", :spacing => 2
    
    
    # función de generación de la tabla de Conceptos para modelos de tipo Servicio en el PDF
    table=Proc.new do |recurso, hoja|
      PDF::SimpleTable.new do |tab|
        tab.title = "Conceptos"
        tab.bold_headings = true
        tab.heading_font_size = 10

        tab.column_order.push(*%w(c1 c2 c3 c4))
        
        tab.columns["c1"] = PDF::SimpleTable::Column.new("c1") { |col|
                  col.heading = " Nombre "
                }
                tab.columns["c2"] = PDF::SimpleTable::Column.new("c2") { |col|
                  col.heading = "Valor "
                }
                tab.columns["c3"] = PDF::SimpleTable::Column.new("c3") { |col|
                  col.heading = " Costo "
                }
                tab.columns["c4"] = PDF::SimpleTable::Column.new("c4") { |col|
                  col.heading = "Disponible  "
                }
        tab.show_lines    = :all
        tab.show_headings = true
        tab.orientation   = :center
        tab.position      = :center
               
        if recurso.instance_of? Servicio
          data= recurso.conceptos.map do |concepto|
            {"c1" => concepto.metaconcepto.nombre.toutf_8, "c2" => concepto.valor_, "c3" => concepto.costo_, "c4" => concepto.disponibilidad.toutf_8 }
          end
        else
          data= recurso.concepto_clones.map do |concepto|
            {"c1" => concepto.metaconcepto_nombre.toutf_8, "c2" => concepto.valor_, "c3" => concepto.costo_, "c4" => concepto.disponibilidad.toutf_8 }
          end
        end
        
        
        
        tab.data.replace data
        tab.render_on(hoja)
      end
    end
    
    # De cada log hay que obtener su tipo y entonces sus atributos
    logs.each_with_index do |log, index|
      recurso = log.recurso
      
      pdf.text "<i><b>#{log.recurso_type.gsub("Clon", "").toutf_8}</b> #{index+1}</i> (#{log.accion.toutf_8}) <i>por</i> #{log.usuario.login.toutf_8} : <b>#{I18n.localize(log.fecha_de_creacion, :format => :short)}</b>", :font_size => 12
      pdf.text " ", :spacing => 1
      
      
      if recurso.nil?
          pdf.text "Los datos del registro de éste documento no están disponibles. \n <b>Probablemente #{log.recurso_type.gsub("Clon", "")}</b> haya sido eliminado".toutf_8, :justification => :center, :spacing => 1
      elsif recurso.instance_of? Paquete
          pdf.text "<b>Plaza</b>: #{recurso.plaza.nombre.toutf_8}", :font_size => 10
          pdf.text "<b>Zona</b>: #{recurso.zona_.toutf_8}", :font_size => 10
          pdf.text "<b>Costo (1-10)</b>: #{recurso.costo_primer_mitad_de_mes.toutf_8}", :font_size => 10
          pdf.text "<b>Costo (11-31)</b>: #{recurso.costo_segunda_mitad_de_mes.toutf_8}", :font_size => 10
          pdf.text "<b>Costo Real</b>: #{recurso.costo_real_.toutf_8}", :font_size => 10
          pdf.text "<b>Ahorro</b>: #{recurso.ahorro_.toutf_8}", :font_size => 10
          pdf.text "<b>Servicios</b>: #{recurso.servicios_incluídos.toutf_8}", :font_size => 10
      elsif recurso.instance_of? PaqueteClon
          pdf.text "<b>Plaza</b>: #{recurso.plaza_nombre.toutf_8}", :font_size => 10
          pdf.text "<b>Zona</b>: #{recurso.zona_nombre.toutf_8}", :font_size => 10
          pdf.text "<b>Costo (1-10)</b>: #{recurso.costo_primer_mitad_de_mes.toutf_8}", :font_size => 10
          pdf.text "<b>Costo (11-31)</b>: #{recurso.costo_segunda_mitad_de_mes.toutf_8}", :font_size => 10
          pdf.text "<b>Costo Real</b>: #{recurso.costo_real_.toutf_8}", :font_size => 10
          pdf.text "<b>Ahorro</b>: #{recurso.ahorro_.toutf_8}", :font_size => 10
          pdf.text "<b>Servicios</b>: #{recurso.servicios_incluidos.toutf_8}", :font_size => 10
      elsif recurso.instance_of? Servicio
          pdf.text "<b>Plaza</b>: #{recurso.plaza_.toutf_8}", :font_size => 10
          pdf.text "<b>Subservicio:</b>: #{recurso.nombre_del_servicio.toutf_8}", :font_size => 10
          pdf.text "<b>Servicio:</b>: #{recurso.tipo_de_servicio.toutf_8}", :font_size => 10
          pdf.text "<b>Conceptos:</b>: #{recurso.conceptos.count}", :font_size => 10
          table.call(recurso, pdf)
      elsif recurso.instance_of? ServicioClon
          pdf.text "<b>Plaza</b>: #{recurso.plaza_nombre.toutf_8}", :font_size => 10
          pdf.text "<b>Subservicio:</b>: #{recurso.metasubservicio_nombre.toutf_8}", :font_size => 10
          pdf.text "<b>Servicio:</b>: #{recurso.metaservicio_nombre.toutf_8}", :font_size => 10
          pdf.text "<b>Conceptos:</b>: #{recurso.concepto_clones.count}", :font_size => 10
          pdf.text " ", :spacing => 1
          table.call(recurso, pdf)
      elsif recurso.instance_of? Cobertura
          pdf.text "<b>Plaza</b> #{recurso.plaza.nombre.toutf_8}", :font_size => 10
          pdf.text "<b>Nombre</b> #{recurso.nombre.toutf_8}", :font_size => 10
          pdf.text "<b>Número de nodo</b> #{recurso.numero_de_nodo}".toutf_8, :font_size => 10
          pdf.text "<b>Calle</b> #{recurso.calle.toutf_8}", :font_size => 10
          pdf.text "<b>Colonia</b> #{recurso.colonia.toutf_8}", :font_size => 10
      elsif recurso.instance_of? CoberturaClon
          pdf.text "<b>Plaza</b> #{recurso.plaza_nombre.toutf_8}", :font_size => 10
          pdf.text "<b>Nombre</b> #{recurso.nombre.toutf_8}", :font_size => 10
          pdf.text "<b>Número de nodo</b> #{recurso.numero_de_nodo}".toutf_8, :font_size => 10
          pdf.text "<b>Calle</b> #{recurso.calle.toutf_8}", :font_size => 10
          pdf.text "<b>Colonia</b> #{recurso.colonia.toutf_8}", :font_size => 10
      end
      pdf.text "\n\n"
    end
    
    return pdf
  end
    
    

end