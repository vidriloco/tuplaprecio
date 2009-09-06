require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cobertura do
  before(:each) do
    @valid_attributes = {
      :nombre => "value for nombre",
      :numero_de_nodo => 1,
      :colonia => "value for colonia",
      :calle => "value for calle"
    }
  end

  it "should create a new instance given valid attributes" do
    Cobertura.create!(@valid_attributes)
  end
end
