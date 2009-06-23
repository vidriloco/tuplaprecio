require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Concepto do
  
#  it "should expose it's contents in  a readable format" do
#    concepto=Factory.build(:concepto_ligado_a_tipo_a)
#    exposure=concepto.expose
#    exposure.should have(6).items
#    exposure[0].should == "Concepto :"
#    exposure[1].should == ""
#  end
  
  it "should require that it's attribute 'costo' is a number if it's associated metaconcepto is of 'tipo' 'A'" do
    concepto = Factory.build(:concepto, :costo => "esto no es un número")
    concepto.metaconcepto = Factory.create(:metaconcepto_tipo_a)
    concepto.save.should be_false
  end
  
  it "should require that it's attribute 'valor' is a number if it's associated metaconcepto is of 'tipo' 'B'" do
    concepto = Factory.build(:concepto, :valor => "esto no es un número")
    concepto.metaconcepto = Factory.create(:metaconcepto_tipo_b)
    concepto.save.should be_false
  end
  
  it "should be possible to build a new instance of concepto tipo 'A' provided the correct values" do
    concepto = Factory.build(:concepto, :valor => nil)
    concepto.metaconcepto = Factory.create(:metaconcepto_tipo_a)
    concepto.save.should be_true
  end
  
  it "should be possible to build a new instance of concepto tipo 'B' provided the correct values" do
    concepto = Factory.build(:concepto, :costo => nil)
    concepto.metaconcepto = Factory.create(:metaconcepto_tipo_b)
    concepto.save.should be_true
  end
  
  it "should return the value of it's attribute 'costo' in a human readable format" do
    concepto = Factory.build(:concepto)
    concepto.costo_.should == "$ #{concepto.costo} pesos"
  end
  
  it "should require that it's attribute 'valor' is not blank if it's associated metaconcepto is of 'tipo' 'B'" do
    concepto = Factory.build(:concepto, :valor => "")
    concepto.metaconcepto = Factory.build(:metaconcepto_tipo_b)
    concepto.save.should be_false
  end
  
  it "should require that it's attribute 'costo' is not nil if it's associated metaconcepto is of 'tipo' 'A'" do
    concepto = Factory.build(:concepto, :costo => "")
    concepto.metaconcepto = Factory.build(:metaconcepto_tipo_a)
    concepto.save.should be_false
  end
  
  it "should return in a human readable format the value of it's attribute 'vigente_desde'"
  
  it "should return in a human readable format the value of it's attribute 'vigente_hasta'"
  
end