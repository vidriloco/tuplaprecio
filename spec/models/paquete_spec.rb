require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Paquete do
  
  before(:each) do
    @usuario = Factory.create(:usuario_completo_encargado)
    # mimic value set on controller before_filter
    Thread.current['usuario'] = @usuario.id
  end
  
  context "creating a paquete" do
    before(:each) do
      @paquete = Factory.create(:paquete_doble_play)
      @log = Log.find :last
    end
    
    it "should create a log record" do
      @log.should_not be_nil
    end
    
    it "should create a log record with valid usuario" do
      @usuario.should be_eql(@log.usuario)
    end
    
    it "should create a log record with valid paquete" do
      @paquete.should be_eql(@log.recurso)
    end
    
    it "should create a log record with valid accion" do
      @log.accion.should == "crear" 
    end
  end
  
  context "modifying a paquete" do
     before(:each) do
       @paquete = Factory.create(:paquete_doble_play)
       #Destroy creation log for checking modification behaviour 
       Log.first.destroy
       @paquete.update_attribute(:internet, "1 MBPS")
       @log = Log.find :last
     end

     it "should create a log record" do
       @log.should_not be_nil
     end

     it "should create a log record with valid usuario" do
       @usuario.should be_eql(@log.usuario)
     end

     it "should create a log record with valid paquete" do
       @paquete.should be_eql(@log.recurso)
     end

     it "should create a log record with valid accion" do
       @log.accion.should == "modificar" 
     end
   end
  
   context "deleting a paquete" do
     before(:each) do
       @paquete = Factory.create(:paquete_doble_play)
       #Destroy creation log for checking deletion behaviour 
       Log.first.destroy
       @paquete.destroy
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
         @paquete_clon = PaqueteClon.find :first
       end
       
       it "should create a log record with a valid paquete clone 1" do
         @paquete_clon.log.should be_eql(@log)
       end
     
       it "should create a log record with a valid paquete clone 2" do
         @paquete_clon.should be_eql(@log.recurso)
       end
     end

     it "should create a log record with valid accion" do
       @log.accion.should == "eliminar" 
     end
   end
  
end