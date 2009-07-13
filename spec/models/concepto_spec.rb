require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Concepto do
  
#  it "should expose it's contents in  a readable format" do
#    concepto=Factory.build(:concepto_ligado_a_tipo_a)
#    exposure=concepto.expose
#    exposure.should have(6).items
#    exposure[0].should == "Concepto :"
#    exposure[1].should == ""
#  end
  
  describe "disponible" do
    describe "associated to metaconcepto 'tipo' A" do
  
      it "should require that it's attribute 'costo' is a number" do
        concepto = Factory.build(:concepto, :costo => "esto no es un número")
        concepto.metaconcepto = Factory.create(:metaconcepto_tipo_a)
        concepto.save.should be_false
      end
  
      it "should correctly save provided the correct values" do
        concepto = Factory.build(:concepto, :valor => nil)
        concepto.metaconcepto = Factory.create(:metaconcepto_tipo_a)
        concepto.save.should be_true
      end
  
      it "should require that it's attribute 'costo' is not nil" do
        concepto = Factory.build(:concepto, :costo => nil)
        concepto.metaconcepto = Factory.build(:metaconcepto_tipo_a)
        concepto.save.should be_false
      end
      
      it "should correctly retrieve stored values" do
        concepto = Factory.build(:concepto, :valor => nil, :costo => 100.00)
        concepto.metaconcepto = Factory.create(:metaconcepto_tipo_b)
        concepto.save
        concepto.valor.should be_nil
        concepto.costo.should == 100.00
      end
    end
  
    describe "associated to metaconcepto 'tipo' B" do
  
      it "should require that it's attribute 'valor' is a number" do
        concepto = Factory.build(:concepto, :valor => "esto no es un número")
        concepto.metaconcepto = Factory.create(:metaconcepto_tipo_b)
        concepto.save.should be_false
      end
 
      it "should correctly save provided the correct values" do
        concepto = Factory.build(:concepto, :costo => nil)
        concepto.metaconcepto = Factory.create(:metaconcepto_tipo_b)
        concepto.save.should be_true
      end
      
      it "should correctly retrieve stored values" do
        concepto = Factory.build(:concepto, :valor => 4, :costo => nil)
        concepto.metaconcepto = Factory.create(:metaconcepto_tipo_b)
        concepto.save
        concepto.valor.should == 4
        concepto.costo.should be_nil
      end
  
      it "should require that it's attribute 'valor' is not nil" do
        concepto = Factory.build(:concepto, :valor => "")
        concepto.metaconcepto = Factory.build(:metaconcepto_tipo_b)
        concepto.save.should be_false
      end
    end
    
    it "should return the value of it's attribute 'costo' in a human readable format" do
      concepto = Factory.build(:concepto)
      concepto.costo_.should == "$ #{concepto.costo.to_s(2)}"
    end
    
  end
  
  describe "no disponible" do
    describe "associated to metaconcepto 'tipo' A" do
  
      it "should not validate that it's attribute 'costo' is a number" do
        concepto = Factory.build(:concepto, :costo => "esto no es un número", :disponible => false)
        concepto.metaconcepto = Factory.create(:metaconcepto_tipo_a)
        concepto.save.should be_true
      end
  
      it "should correctly save when metaconcepto is the only not nil value" do
        concepto = Factory.build(:concepto, :costo => nil, :valor => nil, :disponible => false)
        concepto.metaconcepto = Factory.create(:metaconcepto_tipo_a)
        concepto.save.should be_true
      end
  
      it "should not matter that it's attribute 'costo' is nil" do
        concepto = Factory.build(:concepto, :costo => nil, :disponible => false)
        concepto.metaconcepto = Factory.create(:metaconcepto_tipo_a)
        concepto.save.should be_true
      end
    end
  
    describe "associated to metaconcepto 'tipo' B" do
  
      it "should not validate that it's attribute 'costo' is a number" do
        concepto = Factory.build(:concepto, :costo => "esto no es un número", :disponible => false)
        concepto.metaconcepto = Factory.create(:metaconcepto_tipo_b)
        concepto.save.should be_true
      end
  
      it "should correctly save when metaconcepto is the only not nil value" do
        concepto = Factory.build(:concepto, :costo => nil, :valor => nil, :disponible => false)
        concepto.metaconcepto = Factory.create(:metaconcepto_tipo_b)
        concepto.save.should be_true
      end
  
      it "should not matter that it's attribute 'value' is nil" do
        concepto = Factory.build(:concepto, :valor => nil, :disponible => false)
        concepto.metaconcepto = Factory.create(:metaconcepto_tipo_b)
        concepto.save.should be_true
      end
    end
    
    it "should return the value of it's attribute 'costo' in a human readable format" do
      concepto = Factory.build(:concepto)
      concepto.costo_.should == "$ #{concepto.costo.to_s(2)}"
    end

  
  end
  
  
end