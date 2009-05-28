require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Usuario do


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
    Usuario.authenticate("usuario1", "usuario1passw").should be_a(Usuario)
  end
  
  it "should output a correct string when usuario id is not nil" do
    usuario=Factory.build(:usuario)
    usuario.save
    Usuario.salida_usuario(usuario.id).should eql("<b>#{usuario.login}</b>")
  end
  
  it "should output a 'No asignable' legend when usuario is in level 3" do
    Factory.create(:administracion)
    usuario=Factory.build(:usuario_completo_agente)
    usuario.save
    usuario.responsable_de.should eql("No asignable")
  end
  
  it "should output a 'No asignado aún' legend when usuario's responsabilidad is set to nil" do
    Factory.create(:administracion)
    usuario=Factory.build(:usuario_completo_encargado, :responsabilidad => nil)
    usuario.save
    usuario.responsable_de.should eql("No asignado aún")
  end
  
  it "should output a 'Plaza' legend when usuario's responsabilidad is not nil and the user is in level 2" do
    Factory.create(:administracion)
    usuario=Factory.build(:usuario_completo_encargado)
    usuario.save
    usuario.responsable_de.should eql("Plaza")
  end
  
  it "should output a 'Administracion' legend when usuario's responsabilidad is not nil and the user is in level 1" do
    Factory.create(:administracion)
    usuario=Factory.build(:usuario_completo_admin)
    usuario.save
    usuario.responsable_de.should eql("Administracion")
  end
  
  it "should output the Plaza nombre of any user which is on level 2" do
    Factory.create(:administracion)
    usuario=Factory.build(:usuario_completo_encargado)
    usuario.save
    usuario.detalles_responsabilidad.should eql("Plaza: #{usuario.responsabilidad.nombre}")
    
  end
  
end
