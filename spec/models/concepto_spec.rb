require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Concepto do
  
  it "should expose it's contents in  a readable format" do
    concepto=Factory.build(:concepto, :nombre => "alguno")
    exposure=concepto.expose
    exposure.should have(2).items
    exposure[0].should == "Concepto :"
    exposure[1].should == "alguno"
  end
  
end