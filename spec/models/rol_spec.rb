require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rol do
  
  it "should not create a new nivel 1 role when a nombre for the rol is not provided" do
    rol=Factory.build(:rol_nivel_1, :nombre => "")
    rol.should_not be_valid
  end
  
  it "should not create a new nivel 2 role when a nombre for the rol is not provided" do
    rol=Factory.build(:rol_nivel_2, :nombre => "")
    rol.should_not be_valid
  end
  
  it "should not create a new nivel 3 role when a nombre for the rol is not provided" do
     rol=Factory.build(:rol_nivel_3, :nombre => "")
     rol.should_not be_valid
  end
  
end