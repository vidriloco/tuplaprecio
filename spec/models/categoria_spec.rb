require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Categoria do
  
  it "should expose it's contents in  a readable format" do
    categoria=Factory.build(:categoria, :nombre => "alguna")
    exposure=categoria.expose
    exposure.should have(2).items
    exposure[0].should == "Categoría :"
    exposure[1].should == "alguna"
  end
  
end