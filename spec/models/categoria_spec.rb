require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Categoria do
  
  it "should be possible to add new conceptos to this categoria" do
    categoria=Factory.create(:categoria)

    counter=1
    while(counter < 6) do
      categoria.agrega_nuevo_concepto Factory.create(:concepto)
      counter+=1
      categoria.should have(counter).conceptos
    end
  end
  
end