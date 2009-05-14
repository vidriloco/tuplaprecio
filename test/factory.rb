module Factory

  def self.included(base)
    base.extend(self)
  end

  def build(params = {})
    raise "There are no default params for #{self.name}" unless self.respond_to?(self.name.underscore)
    new(self.send(self.name.underscore).merge(params))
  end

  def build!(params = {})
    obj = build(params)
    obj.save!
    obj
  end
  
  def plaza
    {
     :nombre => "Querétaro",
     :estado => Estado.build,
    }
  end
  
  def estado
    {
      :nombre => "Querétaro"
    }
  end
  
  def presentacion
    {
      :nombre => "Promocíón Estelar",
      :combo => true,
      :costo => rand(300),
    }
  end
  
  def servicio
    {
      :nombre => "Internet",
      :costo_normal => 302
    }
  end
  
  def concepto
    {
      :nombre => "Venta de televisión" 
    }
  end
  
  def usuario
    {
      :login => "fulanito",
      :email => "fulanito@example.com",
      :password => "password de fulanito",
      :password_confirmation => "password de fulanito"
    }
  end
  
  def administracion
    {
      
    }
  end
  
end

ActiveRecord::Base.class_eval do
  include Factory
end