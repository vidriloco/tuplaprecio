require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Especializado do
  
  it "should retrieve the name of the concepto it's related servicio belongs to" do
    
  end
  
  it "should retrieve the name of the categoria it's related servicio belongs to" do

  end
  
  it "should retrieve a not null detalles for it's related servicio" do
    
  end
  
  it "should inform in human readable format wheter it's an active service or not" do
    
  end
  
  it "should correctly retrieve the cost of the service local to the plaza it has been assigned to" do
    #f=Factory.build(:especializado)
    #f.costo_.should be_eql("$ 200 pesos")
  end
  
  it "should expose it's contents in  a readable format" do
    #concepto=Factory.build(:concepto, :nombre => "alguno")
    #exposure=concepto.expose
    #exposure.should have(2).items
    #exposure[0].should == "Concepto :"
    #exposure[1].should == "alguno"
  end
  
  it "should correctly retrieve the instances that accomplish a given numerical input value" do
    e1=Factory.create(:especializado, :servicio => nil)
    e2=Factory.create(:especializado, :costo => 300, :servicio => nil)
    # El parámetro para busca es un arreglo, pues en el controller se pasa el 
    # resultado de una operación split sobre una cadena
    Especializado.busca(["300"])[0].should eql(e2)
    Especializado.busca(["200"])[0].should eql(e1)
  end
  
  it "should return no instances when given a not numerical input value" do
    e1=Factory.create(:especializado, :servicio => nil)
    e2=Factory.create(:especializado, :costo => 300, :servicio => nil)
    # El parámetro para busca es un arreglo, pues en el controller se pasa el 
    # resultado de una operación split sobre una cadena
    Especializado.busca(["pepito", "luis"]).should be_empty
    Especializado.busca(["carmen", "filigonia"]).should be_empty
  end
  
  it "should correctly retrieve the instances that accomplish a given numerical input value even though not numerical input values are also given" do
    e1=Factory.create(:especializado, :servicio => nil)
    e2=Factory.create(:especializado, :costo => 300, :servicio => nil)
    # El parámetro para busca es un arreglo, pues en el controller se pasa el 
    # resultado de una operación split sobre una cadena
    Especializado.busca(["300", "Carlos"])[0].should eql(e2)
    Especializado.busca(["200", "dominico", "Suecia"])[0].should eql(e1)
  end
  
end