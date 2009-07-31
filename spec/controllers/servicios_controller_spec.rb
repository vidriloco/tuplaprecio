require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ServiciosController do

  context "a encargado usuario is logged in" do

    before(:each) do
      @usuario = Factory.create(:usuario_completo_encargado)
      controller.stub!(:current_user).and_return @usuario
    end
    
    context "then it should be possible to create a servicio which" do
      
      it "should cause a new record to be created in table servicios" do
        lambda { 
          post :create, :servicio => Factory.build(:servicio).attributes.symbolize_keys
        }.should change{ Servicio.count } 
      end
      
      it "should cause a new record to be created in table conceptos when has conceptos related to it" do
        lambda { 
          post :create, :servicio => Factory.build(:servicio).attributes.symbolize_keys, 
                        :conceptos => {:c1 => Factory.build(:concepto_con_metaconcepto_tipo_A).attributes.symbolize_keys, 
                                       :c2 => Factory.build(:concepto_con_metaconcepto_tipo_B).attributes.symbolize_keys }
        }.should change{ Concepto.count } 
      end
      
      context "have values for attributes" do
      
        before(:each) do
          @s = Factory.build(:servicio)
          post :create, :servicio => @s.attributes.symbolize_keys
          # Last added servicio
          @servicio = Servicio.find(:last)
        end
      
        it "should belong to the same plaza usuario is assigned" do
         @servicio.plaza.nombre.should be_eql(@usuario.plaza.nombre)
        end
        
        it "should belong to the same metasubservicio" do
          @servicio.metasubservicio.nombre.should be_eql(@s.metasubservicio.nombre)
        end
      end
    end
    
    context "edit action" do
      before(:each) do
        Thread.current['usuario'] = @usuario.id
        # Must previously exist
        @servicio = Factory.create(:servicio)
      end
      
      it "should find the servicio that will be modified" do
        Servicio.should_receive(:find).and_return(@servicio)
        get :edit, :id => @servicio.id
      end
      
      it "should call actualiza_metaconceptos" do
        Servicio.stub!(:find).and_return(@servicio)
        @servicio.should_receive(:actualiza_conceptos).and_return(@metasubservicios = @servicio.metasubservicio.metaservicio.metasubservicios)
        get :edit, :id => @servicio.id
      end
    end
    
    context "then it should be possible to modify a servicio and" do
      
      before(:each) do
        Thread.current['usuario'] = @usuario.id
        # Must previously exist
        @servicio = Factory.create(:servicio)
      end
        
        it "should find and return servicio" do
          Servicio.should_receive(:find).with(@servicio.id.to_s).and_return(@servicio)          
          put :update, :id => @servicio.id, :servicio => {}
        end
        
        it "should update servicio" do
          Servicio.stub!(:find).and_return(@servicio)
          @servicio.should_receive(:update_attributes).and_return(:true)
          put :update, :id => @servicio.id, :servicio => {}
        end
      
    end
    
    context "after creating a servicio" do   
      context "log properties" do
      
        before(:each) do
          post :create, :servicio => Factory.build(:servicio).attributes.symbolize_keys
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
    
    context "updating a servicio who has conceptos related to it" do
      before(:each) do   
         Thread.current['usuario'] = @usuario.id
         # Must previously exist
         @servicio = Factory.build(:servicio)
         @servicio.conceptos << Factory.create(:concepto_con_metaconcepto_tipo_A) 
         @servicio.save
         Log.find(:first).destroy
      end
      
      it "should create a new log upon update_attributes" do
        Servicio.stub!(:update_attributes).and_return(true)
        put :update, :servicio => { }, :id => @servicio.id
        
        Log.find(:first).recurso.id == @servicio.id
      end
      
      it "should create a new log upon conceptos update_attributes" do
        @servicio.stub!(:adjunta_conceptos)
        put :update, :id => @servicio.id, :conceptos => { }        
        
        Log.find(:first).recurso.id == @servicio.id
      end
  
    end
    
    context "after updating a servicio" do
      before(:each) do   
         #servicio must previously exist
         post :create, :servicio => Factory.build(:servicio).attributes.symbolize_keys    
         @servicio = Servicio.find(:first)
         Log.find(:first).destroy
      end
    
      context "log table" do
      
        before(:each) do
          put :update, :servicio => {:plaza_id => 122}, :id => @servicio.id
          @log = Log.find(:first)
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
    
    context "after deleting a servicio" do
      
      context "which has no conceptos" do
        before(:each) do   
           #servicio must previously exist
           post :create, :servicio =>  Factory.build(:servicio).attributes.symbolize_keys
           Log.find(:first).destroy 
           @servicio = Servicio.find(:first)
        end
    
        context "log table" do
      
          before(:each) do
            delete :destroy, :id => @servicio.id
            @log = Log.find(:first)
          end
      
          it "should have a new record" do
            @log.should_not be_nil
          end
    
          it "should have a new record associated to the current user" do
            @log.usuario.should be_eql(@usuario)
          end
      
          it "should have a new record whose recurso points to the servicio clone" do
            @servicio_clon = ServicioClon.find(:first)
            @log.recurso.should be_eql(@servicio_clon)
          end
          
          context "should create a consistent clon of servicio which" do
            
            before(:each) do
              @servicio_clon = ServicioClon.find(:first)
            end
            
            it "should have the same costo_1_10 value" do
              @servicio.plaza.nombre.should be_eql(@servicio_clon.plaza_nombre)
            end
            
            it "should have the same costo_11_31 value" do
              @servicio.plaza.estado.nombre.should be_eql(@servicio_clon.estado_nombre)
            end
            
            it "should have the same costo_real value" do
              @servicio.metasubservicio.nombre.should be_eql(@servicio_clon.metasubservicio_nombre)
            end
            
            it "should have the same ahorro value" do
              @servicio.metasubservicio.metaservicio.nombre.should be_eql(@servicio_clon.metaservicio_nombre)
            end
            
          end
      
          it "should have a new record associated to the accion eliminar" do
            @log.accion.should == "eliminar"
          end
    
        end  
      end
      
      context "which has conceptos" do
        before(:each) do   
           @c1 = Factory.build(:concepto_con_metaconcepto_tipo_A)
           @c2 = Factory.build(:concepto_con_metaconcepto_tipo_B)
           #servicio must previously exist
           post :create, :servicio =>  Factory.build(:servicio).attributes.symbolize_keys, 
                         :conceptos => {:c1 => @c1.attributes.symbolize_keys, :c2 => @c2.attributes.symbolize_keys}
           Log.find(:first).destroy 
           @servicio = Servicio.find(:last)
        end
    
        context "log table" do
      
          before(:each) do
            delete :destroy, :id => @servicio.id
            @log = Log.find(:first)
          end
      
          it "should have a new record" do
            @log.should_not be_nil
          end
    
          it "should have a new record associated to the current user" do
            @log.usuario.should be_eql(@usuario)
          end
      
          it "should have a new record whose recurso points to the servicio clone" do
            @servicio_clon = ServicioClon.find(:first)
            @log.recurso.should be_eql(@servicio_clon)
          end
          
          context "should create a consistent clone of servicio which" do
            
            before(:each) do
              @servicio_clon = ServicioClon.find(:first)
            end
            
            it "should have the same costo_1_10 value" do
              @servicio.plaza.nombre.should be_eql(@servicio_clon.plaza_nombre)
            end
            
            it "should have the same costo_11_31 value" do
              @servicio.plaza.estado.nombre.should be_eql(@servicio_clon.estado_nombre)
            end
            
            it "should have the same costo_real value" do
              @servicio.metasubservicio.nombre.should be_eql(@servicio_clon.metasubservicio_nombre)
            end
            
            it "should have the same ahorro value" do
              @servicio.metasubservicio.metaservicio.nombre.should be_eql(@servicio_clon.metaservicio_nombre)
            end
            
            it "should have two referenced concepto_clones" do
              @servicio_clon.concepto_clones.should have(2).concepto_clones
            end
            
            context "has conceptos asociated" do
              
              before(:each) do
                @concepto_clon_1 = @servicio_clon.concepto_clones[0]
                @concepto_clon_2 = @servicio_clon.concepto_clones[1]                
              end
            
              it "should have the same disponible value" do
                @concepto_clon_1.disponible.should == @c1.disponible
              end
              
              it "should have the same valor value" do
                @concepto_clon_1.valor.should == @c1.valor
              end
              
              it "should have the same costo value" do
                @concepto_clon_1.costo.should == @c1.costo
              end
              
              it "should have the comentarios costo value" do
                @concepto_clon_1.comentarios.should == @c1.comentarios
              end
              
              it "should have the same metaconcepto_nombre value" do
                @concepto_clon_1.metaconcepto_nombre.should == @c1.metaconcepto.nombre
              end
              
              it "should have the same metaconcepto_tipo value" do
                @concepto_clon_1.metaconcepto_tipo.should == @c1.metaconcepto.tipo
              end
              
              it "should have the same disponible value" do
                @concepto_clon_2.disponible.should == @c2.disponible
              end
              
              it "should have the same valor value" do
                @concepto_clon_2.valor.should == @c2.valor
              end
              
              it "should have the same costo value" do
                @concepto_clon_2.costo.should == @c2.costo
              end
              
              it "should have the comentarios costo value" do
                @concepto_clon_2.comentarios.should == @c2.comentarios
              end
              
              it "should have the same metaconcepto_nombre value" do
                @concepto_clon_2.metaconcepto_nombre.should == @c2.metaconcepto.nombre
              end
              
              it "should have the same metaconcepto_tipo value" do
                @concepto_clon_2.metaconcepto_tipo.should == @c2.metaconcepto.tipo
              end
            end
            
          end
      
          it "should have a new record associated to the accion eliminar" do
            @log.accion.should == "eliminar"
          end
    
        end  
      end 
    end
    
  end
  
  

end