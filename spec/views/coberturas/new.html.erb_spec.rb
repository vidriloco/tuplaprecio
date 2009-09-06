require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/coberturas/new.html.erb" do
  include CoberturasHelper

  before(:each) do
    assigns[:cobertura] = stub_model(Cobertura,
      :new_record? => true,
      :nombre => "value for nombre",
      :numero_de_nodo => 1,
      :colonia => "value for colonia",
      :calle => "value for calle"
    )
  end

  it "renders new cobertura form" do
    render

    response.should have_tag("form[action=?][method=post]", coberturas_path) do
      with_tag("input#cobertura_nombre[name=?]", "cobertura[nombre]")
      with_tag("input#cobertura_numero_de_nodo[name=?]", "cobertura[numero_de_nodo]")
      with_tag("input#cobertura_colonia[name=?]", "cobertura[colonia]")
      with_tag("input#cobertura_calle[name=?]", "cobertura[calle]")
    end
  end
end
