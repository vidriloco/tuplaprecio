require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Servicio do
  
  before(:each) do
    @usuario = Factory.create(:usuario_completo_encargado)
    # mimic value set on controller before_filter
    Thread.current['usuario'] = @usuario.id
  end
  
  context "creating a servicio" do
    before(:each) do
      @servicio = Factory.create(:servicio)
      @log = Log.find :last
    end
    
    it "should create a log record" do
      @log.should_not be_nil
    end
    
    it "should create a log record with valid usuario" do
      @usuario.should be_eql(@log.usuario)
    end
    
    it "should create a log record with valid servicio" do
      @servicio.should be_eql(@log.recurso)
    end
    
    it "should create a log record with valid accion" do
      @log.accion.should == "crear" 
    end
  end
  
  context "modifying a servicio" do
    before(:each) do
      @servicio = Factory.create(:servicio)
      #Destroy creation log for checking modification behaviour 
      Log.first.destroy
      @servicio.update_attribute(:plaza_id, 10)
      @log = Log.find :last
    end
  
    it "should create a log record" do
      @log.should_not be_nil
    end
    
    it "should create a log record with valid usuario" do
      @usuario.should be_eql(@log.usuario)
    end
    
    it "should create a log record with valid servicio" do
      @servicio.should be_eql(@log.recurso)
    end
    
    it "should create a log record with valid accion" do
      @log.accion.should == "modificar" 
    end
    
  end
  
  context "deleting a servicio" do
    before(:each) do
      @servicio = Factory.create(:servicio)
      #Destroy creation log for checking deletion behaviour 
      Log.first.destroy
      @servicio.destroy
      @log = Log.find :last
    end
  
    it "should create a log record" do
      @log.should_not be_nil
    end
    
    it "should create a log record with valid usuario" do
      @usuario.should be_eql(@log.usuario)
    end
    
    context "associations" do
      
      before(:each) do
        @servicio_clon = ServicioClon.find :first
      end
      
      it "should create a log record with a valid servicio clone 1" do
        @servicio_clon.log.should be_eql(@log)
      end
    
      it "should create a log record with a valid servicio clone 2" do
        @servicio_clon.should be_eql(@log.recurso)
      end
    end
    
    it "should create a log record with valid accion" do
      @log.accion.should == "eliminar" 
    end
  end
  
  context "assign conceptos on update" do
    before(:each) do
      @servicio = Factory.create(:servicio)
    end
    
    it "should return false on no conceptos" do
      @servicio.adjunta_conceptos(nil).should be_false
    end
    
    it "should assign conceptos to servicio when hash not empty" do
      concepto = Factory.create(:concepto_con_metaconcepto_tipo_A)
      @servicio.conceptos << concepto
      @servicio.save
      @servicio.adjunta_conceptos(concepto.id => {:costo => 800})

      @servicio.conceptos.find(concepto.id).costo.should == 800
    end
  end
  
  context "update conceptos on edit" do
    before(:each) do
      @servicio = Factory.build(:servicio)
      concepto1 = Factory.create(:concepto_con_metaconcepto_tipo_A)
      concepto2 = Factory.create(:concepto_con_metaconcepto_tipo_B)
      @servicio.conceptos += [concepto1, concepto2]
      @servicio.metasubservicio.metaservicio.metaconceptos += [concepto1.metaconcepto, concepto2.metaconcepto]
      @servicio.save
    end
    
    it "should change the number of conceptos when metaconceptos added" do
      metaservicio = @servicio.metasubservicio.metaservicio
      metaservicio.metaconceptos << Factory.create(:metaconcepto_tipo_b)
      lambda {
        @servicio.actualiza_conceptos
      }.should change { @servicio.conceptos }
    end
      
    it "should not change the number of conceptos when metaconceptos not change" do
      lambda {
        @servicio.actualiza_conceptos
      }.should_not change { @servicio.conceptos }
    end
      
  end
  
  
  
end