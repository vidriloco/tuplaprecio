require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ServiciosController do

  context "a encargado usuario is logged in" do

    before(:each) do
      @usuario = Factory.create(:usuario_completo_encargado)
      controller.stub!(:current_user).and_return @usuario
    end
    
    context "after create a servicio" do   
      context "log properties" do
      
        before(:each) do
          post :create, :servicio =>  {:plaza_id => 700, :metasubservicio_id => 342}
          @log = Log.find(:last)
        end
      
        it "should have created a new log record" do
          @log.should_not be_nil
        end
    
        it "should have associated the log to the current user" do
          @log.usuario.should be_eql(@usuario)
        end
      
        it "should have associated the log to the correct servicio" do
          @servicio = Servicio.find(:first)
          @log.recurso.should be_eql(@servicio)
        end
      
        it "should have associated the log to the accion crear" do
          @log.accion.should == "crear"
        end
            
      end   
    end
    
    context "after updating a servicio" do
      before(:each) do   
         #servicio must previously exist
         post :create, :servicio => {:plaza_id => 700, :metasubservicio_id => 342}    
         @servicio = Servicio.find(:first)
      end
    
      context "log properties" do
      
        before(:each) do
          post :update, :servicio => {:plaza_id => 122}, :id => @servicio.id
          @log = Log.find(:last)
        end
      
        it "should have created a new log record" do
          @log.should_not be_nil
        end
    
        it "should have associated the log to the current user" do
          @log.usuario.should be_eql(@usuario)
        end
      
        it "should have associated the log to the correct servicio" do
          @log.recurso.should be_eql(@servicio)
        end
      
        it "should have associated the log to the accion crear" do
          @log.accion.should == "modificar"
        end
    
      end   
    end
    
  end
  
  

end