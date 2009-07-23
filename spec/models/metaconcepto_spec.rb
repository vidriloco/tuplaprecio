require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Metaconcepto do

  it "should create a new metaconcepto instance" do
    Factory.create(:metaconcepto_tipo_a).should be_true
  end
  
  it "should be possible to assign many conceptos to it" do
    mc=Factory.create(:metaconcepto_tipo_a)
    3.times do
      c=Factory.build(:concepto)
      c.metaconcepto = mc
      c.save
    end
    mc.reload.conceptos.should have(3).conceptos
  end
  
  it "should require that it's attribute 'nombre' is not empty" do
    mc=Factory.build(:metaconcepto_tipo_a, :nombre => "")
    mc.should_not be_valid
  end
  
  it "should require that it's attribute 'tipo' is not empty" do
    mc=Factory.build(:metaconcepto_tipo_a, :tipo => "")
    mc.should_not be_valid
  end
  
  it "should delete the conceptos which are linked to it" do
    mc=Factory.create(:metaconcepto_tipo_a)
    3.times do
      co=Factory.build(:concepto, :comentarios => "ligado a un metaconcepto eliminado")
      co.metaconcepto.should be_nil
      co.metaconcepto = mc
      co.save.should be_true
    end
    mc.destroy.should be_equal(mc)
    Concepto.find(:all, :conditions => {:comentarios => "ligado a un metaconcepto eliminado"}).should be_empty
  end
  
  it "should return 'Sin posición' when it has not yet been assigned a posición" do
    mc=Factory.create(:metaconcepto_tipo_a)
    mc.posicion_.should be_eql("Sin posición")
  end
  
end
