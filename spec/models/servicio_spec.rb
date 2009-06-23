require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Servicio do
  
  it "should have associations for one 'subcategoria', 'plaza', for many 'conceptos', 'paquetes'" do
    sv = Factory.create(:servicio)
    sv.subcategoria.should be_nil
    sv.conceptos.should be_an_instance_of Array
    sv.plaza.should be_nil
  end
end