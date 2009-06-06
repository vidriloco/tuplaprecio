require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Servicio do
  
  it "should correctly retrieve the records which have on it's detalles numerical values" do
    servicio=Factory.create(:servicio, :detalles => "El 11 de mayo se vence ésta promoción")
    Servicio.busca(["11"])[0].should == servicio
  end
  
  it "should retrieve the correct value (name) of the categoria it's associated with" do
    servicio=Factory.create(:servicio)
    servicio.con_categoria.should be_eql("unacategoria")
  end
  
  it "should retrieve the correct value (name) of the concepto it's associated with" do
    servicio=Factory.create(:servicio)
    servicio.con_concepto.should be_eql("unconcepto")
  end
  
  it "should retrieve a 'No hay detalles que mostrar' message when detalles_ is blank" do
    servicio=Factory.build(:servicio, :detalles => "")
    servicio.detalles_.should be_eql("No hay detalles que mostrar")
  end
  
  it "should retrieve detalles value if detalles_ is not blank" do
    servicio=Factory.build(:servicio)
    servicio.detalles_.should be_eql("Detalles del servicio")
  end
  
  it "should retrieve an empty array if the given input string does not match anything in the attribute detalles when non blank" do
    servicio=Factory.create(:servicio, :detalles => "El 11 de mayo se vence ésta promoción")
    Servicio.busca(["acambaro"]).should be_empty
  end
  
  it "should correctly retrieve the records whose detalles value includes numerical input values mixed with non numerical" do
    servicio=Factory.create(:servicio, :detalles => "850 instancias ornelas")
    Servicio.busca(["850", "instancias", "ornelas"])[0].should == servicio
  end
  
  it "should expose it's contents in  a readable format" do
    servicio=Factory.build(:servicio)
    exposure=servicio.expose
    exposure.should have(2).items
    exposure[0].should == "Servicio :"
    exposure[1].should == "Detalles del servicio"
  end
end