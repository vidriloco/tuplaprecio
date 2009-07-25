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
    
    it "should create a log record with valid servicio" do
      @servicio.should be_eql(@log.recurso)
    end
    
    it "should create a log record with valid accion" do
      @log.accion.should == "eliminar" 
    end
  end
  
end