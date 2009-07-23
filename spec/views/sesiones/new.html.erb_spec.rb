require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper') 

describe "sesiones/new.html.erb" do
  
  before(:each) do
  end
  
  it "should login on valid user" do
    visit(login)
    fill_in "login", :with => "agente1"
    fill_in "password", :with => "cablecom_agente1"
    click_button "Iniciar Sesión"
    response.should render_template("principal_tres")
  end
  
end