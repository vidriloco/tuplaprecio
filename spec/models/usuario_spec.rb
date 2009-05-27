require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Usuario do
  before(:each) do
  end

  it "should create a new instance given valid attributes" do
    Factory.create(:usuario)
  end
  
  it "should not be valid when password whose length is less than six characters is given" do
    usuario=Factory.build(:usuario, :password => "feote", :password_confirmation => "feote")
    usuario.should_not be_valid
  end
  
  it "should not be valid when usuario login is empty" do
    usuario=Factory.build(:usuario, :login => "")
    usuario.should_not be_valid
  end
  
  it "should not be valid when usuario login length is less than four characters" do
    usuario=Factory.build(:usuario, :login => "fer")
    usuario.should_not be_valid
  end
  
  it "should not be valid when usuario nombre is empty" do
    usuario=Factory.build(:usuario, :nombre => "")
    usuario.should_not be_valid
  end
  
  it "should not be valid when usuario email length is less than six characters" do
    usuario=Factory.build(:usuario, :email => "r@a.u")
    usuario.should_not be_valid
  end
  
  it "should not be valid when usuario email is empty" do
    usuario=Factory.build(:usuario, :email => "")
    usuario.should_not be_valid
  end
  
  it "should not be valid when usuario email exists in the database" do
    Factory.create(:usuario, :email => "fulano@example.com")
    usuario=Factory.build(:usuario, :email => "fulano@example.com")
    usuario.should_not be_valid
  end
  
  it "should return nil if login is blank" do
    Usuario.authenticate("", "password").should be_nil
  end
  
  it "should return nil if password is blank" do
    Usuario.authenticate("login", "").should be_nil
  end
  
  it "should authenticate a previously created usuario" do
    Factory.create(:usuario, :login => "usuario1", :password => "usuario1passw", :password => "usuario1passw")
    Usuario.authenticate("usuario1", "usuario1passw").should be_a Usuario
  end
  
  it "should output a correct string when usuario id is not nil" do
    usuario=Factory.build(:usuario)
    usuario.save
    Usuario.salida_usuario(usuario.id).should eql("<b>#{usuario.login}</b>")
  end
  
end
