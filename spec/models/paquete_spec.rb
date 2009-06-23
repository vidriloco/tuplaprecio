require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Paquete do
  
  it "should return in a human readable format the value of it's attribute 'costo_1'" do
    paquete = Factory.build(:paquete)
    paquete.costo_1_.should == "$ #{paquete.costo_1_10} pesos"
  end
  
  it "should return in a human readable format the value of it's attribute 'costo'" do
    paquete = Factory.build(:paquete)
    paquete.costo_2_.should == "$ #{paquete.costo_11_31} pesos"
  end
  
  it "should return in a human readable format the value of it's attribute 'costo'" do
    paquete = Factory.build(:paquete)
    paquete.costo_real_.should == "$ #{paquete.costo_real} pesos"
  end
  
  it "should return in a human readable format the value of it's attribute 'costo'" do
    paquete = Factory.build(:paquete)
    paquete.ahorro_.should == "$ #{paquete.ahorro} pesos"
  end
  
  it "should be possible to change it's current associated plaza" do
    pq=Factory.build(:paquete)
    pq.plaza.should be_nil
    pl = Factory.build(:plaza)
    pq.plaza = pl
    pq.plaza.should be_equal(pl)
    pq.plaza = Factory.build(:plaza)
    pq.plaza.should_not be_equal(pl)
  end
  
  it "should be possible to assign to it many categorias" do
     pq=Factory.create(:paquete)
     pq.subcategorias.should be_instance_of Array
     3.times do 
       pq.subcategorias << Factory.build(:subcategoria)
     end
     pq.reload.subcategorias.should have(3).subcategorias
  end
  
end