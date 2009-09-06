require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/coberturas/show.html.erb" do
  include CoberturasHelper
  before(:each) do
    assigns[:cobertura] = @cobertura = stub_model(Cobertura,
      :nombre => "value for nombre",
      :numero_de_nodo => 1,
      :colonia => "value for colonia",
      :calle => "value for calle"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ nombre/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ colonia/)
    response.should have_text(/value\ for\ calle/)
  end
end
