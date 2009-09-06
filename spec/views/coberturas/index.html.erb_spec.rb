require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/coberturas/index.html.erb" do
  include CoberturasHelper

  before(:each) do
    assigns[:coberturas] = [
      stub_model(Cobertura,
        :nombre => "value for nombre",
        :numero_de_nodo => 1,
        :colonia => "value for colonia",
        :calle => "value for calle"
      ),
      stub_model(Cobertura,
        :nombre => "value for nombre",
        :numero_de_nodo => 1,
        :colonia => "value for colonia",
        :calle => "value for calle"
      )
    ]
  end

  it "renders a list of coberturas" do
    render
    response.should have_tag("tr>td", "value for nombre".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for colonia".to_s, 2)
    response.should have_tag("tr>td", "value for calle".to_s, 2)
  end
end
