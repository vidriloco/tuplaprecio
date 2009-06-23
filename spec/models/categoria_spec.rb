require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Categoria do
  
  it "should expose it's contents in  a readable format" do
    categoria=Factory.build(:categoria, :nombre => "alguna")
    exposure=categoria.expose
    exposure.should have(2).items
    exposure[0].should == "Categoría :"
    exposure[1].should == "alguna"
  end
  
  it "should be possible to assign subcategorias to it" do
    categoria=Factory.create(:categoria, :nombre => "alguna")
    2.times do
      categoria.subcategorias << Factory.create(:subcategoria, :nombre => "subcategoria de alguna")
    end
    categoria.reload.subcategorias.should have(2).subcategorias
  end  
  
  it "should be possible to assign metaconceptos to it" do
    categoria=Factory.create(:categoria, :nombre => "alguna")
    3.times do
      categoria.metaconceptos << Factory.create(:metaconcepto_tipo_a)
    end
    categoria.reload.metaconceptos.should have(3).metaconceptos
  end
  
  it "should require that it's attribute 'nombre' is not empty" do
    categoria=Factory.build(:categoria, :nombre => "")
    categoria.should_not be_valid
  end
end