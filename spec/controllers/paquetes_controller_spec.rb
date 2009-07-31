require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PaquetesController do

  context "a encargado usuario is logged in" do

    before(:each) do
      @usuario = Factory.create(:usuario_completo_encargado)
      controller.stub!(:current_user).and_return @usuario
    end
    
    context "after creating a paquete" do   
      context "log properties" do
      
        before(:each) do
          post :create, :paquete =>  Factory.build(:paquete_doble_play).attributes.symbolize_keys
          @log = Log.find(:first)
        end

        it "should be a new paquete" do
          Paquete.first.should_not be_nil
        end

        it "should have created a new log record" do
          @log.should_not be_nil
        end
    
        it "should have associated the log to the current user" do
          @log.usuario.should be_eql(@usuario)
        end
      
        it "should have associated the log to the correct paquete" do
          @paquete = Paquete.find(:first)
          @log.recurso.should be_eql(@paquete)
        end
      
        it "should have associated the log to the accion crear" do
          @log.accion.should == "crear"
        end
            
      end   
    end
    
     context "after updating a paquete" do
        before(:each) do   
           #paquete must previously exist
           post :create, :paquete => Factory.build(:paquete_doble_play).attributes.symbolize_keys 
           Log.find(:first).destroy   
           @paquete = Paquete.find(:first)
        end

        context "log properties" do

          before(:each) do
            put :update, :paquete => {:internet => "Internet"}, :id => @paquete.id
            @log = Log.find(:first)
          end

          it "should have created a new log record" do
            @log.should_not be_nil
          end

          it "should have associated the log to the current user" do
            @log.usuario.should be_eql(@usuario)
          end

          it "should have associated the log to the correct servicio" do
            @log.recurso.should be_eql(@paquete)
          end

          it "should have associated the log to the accion modificar" do
            @log.accion.should == "modificar"
          end

        end   
      end
    
      context "after deleting a paquete" do

        before(:each) do   
           #paquete must previously exist
           post :create, :paquete =>  Factory.build(:paquete_doble_play).attributes.symbolize_keys
           Log.find(:first).destroy 
           @paquete = Paquete.find(:first)
        end

        context "log table" do

          before(:each) do
            delete :destroy, :id => @paquete.id
            @log = Log.find(:first)
          end

          it "should have a new record" do
            @log.should_not be_nil
          end

          it "should have a new record associated to the current user" do
            @log.usuario.should be_eql(@usuario)
          end
          
          it "should have a new record whose recurso points to the paquete clone" do
            @paquete_clon = PaqueteClon.find(:first)
            @log.recurso.should be_eql(@paquete_clon)
          end

          context "should create a consistent clon of paquete which" do
            
            before(:each) do
              @paquete_clon = PaqueteClon.find(:first)
            end
            
            it "should have the same costo_1_10 value" do
              @paquete.costo_1_10.should be_eql(@paquete_clon.costo_1_10)
            end
            
            it "should have the same costo_11_31 value" do
              @paquete.costo_11_31.should be_eql(@paquete_clon.costo_11_31)
            end
            
            it "should have the same costo_real value" do
              @paquete.costo_real.should be_eql(@paquete_clon.costo_real)
            end
            
            it "should have the same ahorro value" do
              @paquete.ahorro.should be_eql(@paquete_clon.ahorro)
            end
            
            it "should have the same numero_de_servicios value" do
              @paquete.numero_de_servicios.should be_eql(@paquete_clon.numero_de_servicios)
            end
            
            it "should have the same telefonia value" do
              @paquete.telefonia.should be_eql(@paquete_clon.telefonia)
            end
            
            it "should have the same internet value" do
              @paquete.internet.should be_eql(@paquete_clon.internet)
            end
            
            it "should have the same television value" do
              @paquete.television.should be_eql(@paquete_clon.television)
            end
            
            it "should have the same plaza nombre value" do
              @paquete.plaza.nombre.should be_eql(@paquete_clon.plaza_nombre)
            end
            
            it "should have the same estado nombre value" do
              @paquete.plaza.estado.nombre.should be_eql(@paquete_clon.estado_nombre)
            end
            
            it "should have the same zona nombre value" do
              @paquete.zona.nombre.should be_eql(@paquete_clon.zona_nombre)
            end
          end

          it "should have a new record associated to the accion eliminar" do
            @log.accion.should == "eliminar"
          end
        end 
      end
    
  end
  
  

end