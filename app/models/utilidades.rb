require 'zip/zip'
require 'zip/zipfilesystem'

require 'fastercsv'
require 'migrador'
class Utilidades
        
  MODELOS = ["Estado", "Zona", "Plaza", "Paquete",
         "Metaservicio", "Metasubservicio", "Servicio", "Metaconcepto", "Concepto"]  
  
  def self.genera_zip(archivo_salida="salida_csv")
    t = Tempfile.new("#{@archivo_salida}")
    
    Zip::ZipOutputStream.open(t.path) do |zipfile|
       
       MODELOS.each do |modelo|
        salida = modelo.constantize.report_table(:all, :except => [:updated_at, :created_at]).as(:csv)
        zipfile.put_next_entry("#{modelo}.csv")
        zipfile.print salida
       end
    end
    #Archivo cerrado al final del bloque
    t.path  
  end
  
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
  def self.migracion_exporta_rb(modelos_hash=nil)
    
    if modelos_hash.nil?
      modelos_hash = {:plaza => [:paquete, :servicio], :estado => [:plaza], :servicio => [:concepto], :metasubservicio => [:servicio], 
                      :metaconcepto => [:concepto], :metaconcepto => [:metaservicio]} 
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
        cadena_modelo = "#{modelo.to_s.downcase}_#{m.id} = #{modelo.to_s.capitalize}.new(#{hash_cadena})\n"
        migrador.agrega_marcado(modelo.to_s.downcase, m.id) ? (cadena_guardados << "#{modelo.to_s.downcase}_#{m.id}.save\n") : false
        cadena_final << cadena_modelo
        
      end
      cadena_final
    end
    
    #funcion para generar codigo ruby de cada tupla en la tabla modelo
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
    
    File.open("migracion_ruby.rb", "wb") do |f|
      f.write cadena_de_salida
      f.write cadena_guardados
    end
  end
  
  def self.migracion_importa_rb(archivo)
    f=File.open(archivo.path)
    datos = f.read
    f.close
    eval(datos)
  end
end