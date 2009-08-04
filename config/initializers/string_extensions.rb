class String  
  require 'iconv'  
  def toutf_8
    ic = Iconv.new( 'ISO-8859-15//IGNORE//TRANSLIT', 'utf-8')  
    ic.iconv(self)
  end  
end