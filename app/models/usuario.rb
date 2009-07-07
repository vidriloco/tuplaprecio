require 'digest/sha1'

class Usuario < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Compartido
  
  acts_as_reportable
  
  belongs_to :rol
  belongs_to :plaza

  validates_presence_of     :login,   :message => "no puede estar vacío"
  validates_length_of       :login,    :within => 4 ..40, :message => "es muy corto (mínimo 4 caracteres)"
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => "usa sólo letras, números y .-_@"

  validates_presence_of     :nombre,   :message => "no puede ser vacío"
  validates_length_of       :nombre,   :maximum => 100, :message => "no puede ser mayor a 100 caracteres"

  validates_presence_of     :email,    :message => "no puede estar vacío"
  validates_length_of       :email,    :within => 6..100, :message => "es muy corto (mínimo 6 caracteres)"
  validates_uniqueness_of   :email,    :message => "debe ser único en la base de datos"
  validates_format_of       :email,    :with => Authentication.email_regex, :message => "debe tener la forma que un email tiene"  

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :nombre, :password, :password_confirmation, :rol_id, :plaza_id

  def self.atributos
    ["nombre", "login", "email", "con_rol"]
  end
  
  def self.atributos_exportables
    [:nombre, :login, :email, :crypted_password, :salt, :rol_id, :plaza_id]
  end

  def con_rol
    return rol.nombre unless rol.nil?
    "No asignado aún"
  end
  
  def self.limpia_todos_excepto(este)
    Usuario.all.each do |u|
      u.delete unless u.eql?(este)
    end
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  # Método que devuelve el login de un usuario de manera estilizada en html <b> 
  def self.salida_usuario(usuario_id)
    return false if usuario_id.nil?
    usuario= Usuario.find(usuario_id)
    "<b>#{usuario.login}</b>"
  end
  
  # Devuelve el valor ó en su defecto el estado de la responsabilidad de un usuario
  def responsable_de
   if self.responsabilidad.nil? && Administracion.nivel_de(self.rol.nombre).eql?("nivel 3")
      return "No asignable"
   elsif self.responsabilidad.nil?
      return "No asignado aún" 
   else
      self.responsabilidad_type 
   end
  end
  
  # Devuelve una cadena con detalles sobre la responsabilidad de un usuario
  def detalles_responsabilidad
    if self.responsabilidad.nil? || responsabilidad_type.eql?("Administracion")
      return responsable_de
    else
      "Plaza: #{self.responsabilidad.nombre}"
    end
  end
  
  def self.busqueda
  end
  
  def es_agente?
    return false if rol.nil?
    rol.nombre.eql?("Agente")
  end
  
  def es_administrador?
    return false if rol.nil?
    rol.nombre.eql?("Administrador")
  end
  
  def es_encargado?
    return false if rol.nil?
    rol.nombre.eql?("Encargado")
  end
  
  def no_tiene_rol
    rol.nil?
  end
end
