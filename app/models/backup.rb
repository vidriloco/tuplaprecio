require 'digest/sha1'

class Backup < ActiveRecord::Base
  
  def self.actualiza_hash(objeto)
    first = find(:first)
    digest =  Digest::SHA1.hexdigest(objeto)
    if first.nil?
      create(:security_hash => digest)
    else
      first.update_attribute(:security_hash, digest)
    end
  end
  
  def self.hash_es_el_mismo(objeto)
    first = find(:first)
    return true if first.nil?
    digest = Digest::SHA1.hexdigest(objeto)
    digest.eql? first.security_hash
  end
end