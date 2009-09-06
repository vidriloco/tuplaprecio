require 'digest/sha1'

# Clase encargada de llevar un control de integridad sobre 
# el último archivo de copia de seguridad generado.
class Backup < ActiveRecord::Base
  
  # Método que genera un nuevo Digest para una cadena,
  # que en éste caso corresponde al archivo de copia de
  # seguridad más reciente.
  def self.actualiza_hash(objeto)
    first = find(:first)
    digest =  Digest::SHA1.hexdigest(objeto)
    if first.nil?
      create(:security_hash => digest)
    else
      first.update_attribute(:security_hash, digest)
    end
  end
  
  # Método que analiza si el archivo de copia de seguridad
  # que se va a incorporar a la base de datos actual
  # es consistente.
  def self.hash_es_el_mismo(objeto)
    first = find(:first)
    return true if first.nil?
    digest = Digest::SHA1.hexdigest(objeto)
    digest.eql? first.security_hash
  end
end