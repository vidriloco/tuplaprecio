require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Usuario do
  before(:each) do
    @valid_attributes = {
      :login => "usuario",
      :nombre => "Fulanito Pascual",
      :email => "fulanito_p@example.com"
    }
  end

  it "should create a new instance given valid attributes" do
    Usuario.create!(@valid_attributes)
  end
end
