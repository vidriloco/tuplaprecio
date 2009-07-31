module LogMethods
  
  # This class provides methods to include in models to be audited
  # Ésta clase provee métodos para incluir en modelos que serán auditados
  
  def self.included receiver
      receiver.class_eval do
        # Previous filter to creation of a model instance
        # Filtro previo a la creación de la instancia de un modelo
        after_create do |modelo|
          modelo.registra_en_log(:crear)
        end
        # Previous filter to edition of a model instance
        # Filtro previo a la modificación de la instancia de un modelo
        after_update do |modelo|
          modelo.registra_en_log(:modificar)
        end
        # Previous filter to deletion of a model instance
        # Filtro previo a la eliminación de la instancia de un modelo
        before_destroy do |modelo|
          modelo.registra_en_log(:eliminar)
        end
      end
  end

  def registra_en_log(accion)
    usuario_id = Thread.current['usuario']
    if Usuario.find(usuario_id).es_encargado?
      if accion.eql?(:crear) 
        # Log generation (creation)
        # Generación de Log (creación)
        Log.create!(:usuario_id => usuario_id, 
                    :accion => accion.to_s, 
                    :recurso => self, 
                    :fecha_de_creacion => Time.now.localtime)
      elsif accion.eql?(:modificar)
        # Log generation (edition)
        # Generación de Log (modificación)
        Log.create!(:usuario_id => usuario_id, 
                    :accion => accion.to_s, 
                    :recurso => self, 
                    :fecha_de_creacion => Time.now.localtime)
      elsif accion.eql?(:eliminar)
        # Log generation (deletion)
        # Generación de Log (elimination)
        modelo_clon_id = ActiveRecord::Base.connection.select_value "select clona_recurso('#{self.class.to_s.downcase.pluralize}', #{self.id}, 0);"
        begin
        Log.create!(:usuario_id => usuario_id, 
                    :accion => accion.to_s, 
                    :recurso => "#{self.class.to_s}Clon".constantize.find(modelo_clon_id),
                    :fecha_de_creacion => Time.now.localtime)
        rescue
          raise "Algo feo paso #{modelo_clon_id}"
        end
      end
    end
  end
end