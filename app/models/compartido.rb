# TODO: Share this code

module Compartido
  def before_save
    # other stuff goes here

    # disable automatic ferret indexing...move it to a cron job
    self.disable_ferret(:always)
  end
  
  def self.included receiver
      receiver.extend ClassMethods
      receiver.class_eval do
        @associated, @non_associated, @key_names = [], [], {}
        
        # Establece un número de resultados a mostrar en las vistas por cada página
        def self.per_page
          3
        end
      end
  end
      
    def attributes_which_are(symbol)
      return self.class.get_attributes(symbol)
    end
    
    def lookup_key(key)
      return self.class.get_mapped_key(key)
    end
    
    def drop_attribute_which_is(symbol, atr)
      return self.class.drop_attribute(symbol, atr)
    end
  
    def agrega_desde(params, simbolo={})
       if params.has_key? "usuarios"
         if simbolo.eql? :update
           self.usuarios=[]
         end
         params['usuarios'].each do |usuario_id|
           usuario=Usuario.find(usuario_id)
           unless self.usuarios.exists? usuario
             self.usuarios << usuario
           end
         end
       end
       if params.has_key? "paquetes"
         if simbolo.eql? :update
            self.paquetes=[]
         end
         params['paquetes'].each do |paquete_id|
           paquete=Paquete.find(paquete_id)
           unless self.paquetes.exists? paquete
             self.paquetes << paquete
           end
         end
       end
       if params.has_key? "servicios"
         if simbolo.eql? :update
             self.servicios=[]
          end
         params['servicios'].each do |servicio_id|
           servicio=Servicio.find(servicio_id)
           unless self.servicios.exists? servicio
              self.servicios << servicio
           end
         end
       end
       if params.has_key? "incorporados"
          if simbolo.eql? :update
              self.incorporados=[]
           end
          params['incorporados'].each do |incorporado_id|
            incorporado=Incorporado.find(incorporado_id)
            unless self.incorporados.exists? incorporado
               self.incorporados << incorporado
            end
          end
       end
       if params.has_key? "especializados"
           if simbolo.eql? :update
               self.especializados=[]
            end
           params['especializados'].each do |especializado_id|
             especializado=Especializado.find(especializado_id)
             unless self.especializados.exists? especializado
                self.especializados << especializado
             end
           end
       end
       if params.has_key? "categorias"
         if simbolo.eql? :update
             self.categorias=[]
         end
         params['categorias'].each do |categoria_id|
            categoria=Categoria.find(categoria_id)
            unless self.categorias.exists? categoria
              self.categorias << categoria
            end
         end
       end
     end

     # Devuelve un arreglo con los id's de los instancias de los modelos relacionados a ésta instancia
     # INPUT: Symbol, modelo relacionado (plural)
     # OUTPUT: Array, id's
     def ids_of(related_model)
       eval("self.#{related_model.to_s}.inject([]) {|array, obj|  array<< obj.id; array}")
     end

     def to_html(level, renam={}, meth={})
        assoc = attributes_which_are(:associated)
        non_assoc = attributes_which_are(:non_associated)
        
        if level.instance_of? Level
          level.update(self) 
        elsif level.instance_of? Fixnum
          level = Level.new(level,self)
        end 
        
        output=String.new
        unless level.ancestor_object.eql? self
          div="<div class='#{self.class.to_s}' id='#{id}#{self.class.to_s}'>"
          end_div="</div>"
          output=div
      
          non_assoc.each do |atr|
            output << "<p><i>#{renam[atr.to_sym] || atr.to_s.humanize}:</i>#{ eval(meth[atr.to_sym] || atr.to_s) }</p>"
          end
          output << end_div
        end

        return output if level.level_number == 0
        
        assoc.each do |atr|
          puts "atributos: #{atr.to_s}"
          if eval("#{atr.to_s}").is_a? Array
            eval("#{atr.to_s}").each do |obj|
               call_status = :exceeded
               output << obj.to_html(level) 
            end
          else
            obj = eval("#{atr.to_s}")
            call_status = :exceeded
            output << obj.to_html(level)
          end
        end
        output
     end
     
     def to_hashed_html(level, hash=nil)
       
       hash= Hash.new if hash.nil?
       
       assoc = attributes_which_are(:associated)
       non_assoc = attributes_which_are(:non_associated)
       
       # See if no change on name was provided
       lookedup_key = lookup_key(self.class.to_s)
       key_name = lookedup_key.nil? ? self.class.to_s : lookedup_key
       
       if level.instance_of? Level
         level.update(self) 
       elsif level.instance_of? Fixnum
         level = Level.new(level,self)
         hash[:origin] = key_name
       end 
       
       # Each string construction
       #output="<div class='#{self.class.to_s}' id='#{id}#{self.class.to_s}'>"
       output=String.new
       non_assoc.each do |atr|
         method_evaluation = eval("#{atr.to_s}")
         unless method_evaluation.nil?
           output << "<p><i>#{atr.to_s.humanize.strip}:</i> " + method_evaluation + "</p>"
         end
       end
      
       # Generate the current hash key using the object id and class
       current_hash_key="#{self.class.to_s}-#{id}" 
       
       # Set collection key using object class
       hash[key_name]=Hash.new unless hash.has_key? key_name
       
       # Hash construction
       # If this record has been added already, done
       # else add it together with it's generated output
       unless hash[key_name].has_key? current_hash_key
            hash[key_name][current_hash_key] = output
       end

       return hash if level.level_number == 0
       
       assoc.each do |atr|
         if eval("#{atr.to_s}").is_a? Array
           eval("#{atr.to_s}").each do |obj|
              # actual object should have a not nil association with the declared object
              obj.to_hashed_html(level, hash) unless obj.nil?
           end
         else
           obj = eval("#{atr.to_s}")
           # ditto
           obj.to_hashed_html(level, hash) unless obj.nil?
         end
       end
       hash
     end  
      
   module ClassMethods
     
     def get_attributes(symbol)
       if symbol.eql? :associated
         return @associated
       elsif symbol.eql? :non_associated
         return @non_associated
       end
     end
     
     def drop_attribute(symbol, atribute)
       if symbol.eql? :associated
          @associated.delete(atribute)
        elsif symbol.eql? :non_associated
          @non_associated.delete(atribute)
        end
     end
     
     def attributes_to_serialize(*args)
       args.each do |arg|
         if arg.is_a? Hash
           @associated += arg[:associated]
         elsif arg.is_a? Symbol
           @non_associated << arg
         end
       end
     end
     
     def remap_names(names_hash)
       @key_names = names_hash
     end
     
     def get_mapped_key(key)
       return @key_names[key]
     end
   end

   

   
end