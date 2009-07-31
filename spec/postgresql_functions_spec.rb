require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "PostgreSQL copy function" do
  
  before(:each) do
    @usuario = Factory.create(:usuario_completo_encargado)
    # mimic value set on controller before_filter
    Thread.current['usuario'] = @usuario.id
  end
  
  context "on servicios" do
  
    context "for original and clone with no conceptos associated" do
    
      before(:each) do
        @servicio = Factory.create(:servicio)
        @id_servicio = ActiveRecord::Base.connection.select_value "select clona_recurso('servicios', #{@servicio.id},0)"
      end
    
      it "should have the same plaza and estado" do
        servicio_clon = ServicioClon.first
        @servicio.plaza.nombre.should be_eql(servicio_clon.plaza_nombre)
        @servicio.plaza.estado.nombre.should be_eql(servicio_clon.estado_nombre)
      end
    
      it "should have the same metasubservicio and metaservicio" do
        servicio_clon = ServicioClon.first
        @servicio.metasubservicio.nombre.should be_eql(servicio_clon.metasubservicio_nombre)
        @servicio.metasubservicio.metaservicio.nombre.should be_eql(servicio_clon.metaservicio_nombre)
      end

      it "should build retrieve it's id" do
        @id_servicio.to_i.should == ServicioClon.first.id
      end
    end
  
    context "for original and clone with two or more conceptos (with metaconcepto tipo A and B) associated" do
    
      before(:each) do
        @servicio = Factory.build(:servicio)
        @concepto_A = Factory.create(:concepto_con_metaconcepto_tipo_A)
        @concepto_B = Factory.create(:concepto_con_metaconcepto_tipo_B)
        @servicio.conceptos << @concepto_A
        @servicio.conceptos << @concepto_B
        @servicio.save
      end
    
      context "and PostgreSQL function called NOT from within a servicio call" do
      
        it "should create a clone of concepto with metaconcepto tipo A" do
          ActiveRecord::Base.connection.execute "select clona_recurso('conceptos', #{@concepto_A.id}, 0);"
          concepto_clon = ConceptoClon.find(:first, :conditions => {:metaconcepto_tipo => "A"})
          @concepto_A.metaconcepto.tipo.should be_eql(concepto_clon.metaconcepto_tipo)
        end
      
        it "should create a clone of concepto with metaconcepto tipo B" do
          ActiveRecord::Base.connection.execute "select clona_recurso('conceptos', #{@concepto_B.id}, 0);"
          concepto_clon = ConceptoClon.find(:first, :conditions => {:metaconcepto_tipo => "B"})
          @concepto_B.metaconcepto.tipo.should be_eql(concepto_clon.metaconcepto_tipo)
        end
      end
    
      context "and PostgreSQL function called from within a servicio call" do
      
        it "should create a clone of both: the servicio, concepto, and a link between them which is not nil" do
          ActiveRecord::Base.connection.execute "select clona_recurso('servicios', #{@servicio.id},0);"
          servicio_clon = ServicioClon.first
          servicio_clon.concepto_clones.should_not be_empty
        end
      
        context "both (concepto_A and first concepto) should have" do
          before(:each) do
            ActiveRecord::Base.connection.execute "select clona_recurso('servicios', #{@servicio.id},0);"
            @servicio_clon = ServicioClon.first
            # @concepto_A was inserted first
          end
        
          it "the same disponibilidad" do
            @concepto_A.disponible.should be_eql(@servicio_clon.concepto_clones.first.disponible)
          end
        
          it "the same costo" do
            @concepto_A.costo.should be_eql(@servicio_clon.concepto_clones.first.costo)
          end
        
          it "the same valor" do
            @concepto_A.valor.should be_eql(@servicio_clon.concepto_clones.first.valor)
          end
        
          it "the same comentarios" do
            @concepto_A.comentarios.should be_eql(@servicio_clon.concepto_clones.first.comentarios)
          end
        
          it "the same metaconcepto nombre" do
            @concepto_A.metaconcepto.nombre.should be_eql(@servicio_clon.concepto_clones.first.metaconcepto_nombre)
          end
        
          it "the same metaconcepto tipo" do
            @concepto_A.metaconcepto.tipo.should be_eql(@servicio_clon.concepto_clones.first.metaconcepto_tipo)
          end
        
          context "the same servicio data clone" do
            before(:each) do
              @concepto_clon = ConceptoClon.first
            end
          
            it "and should have the same plaza nombre" do
              @concepto_A.servicio.plaza.nombre.should be_eql(@concepto_clon.servicio_clon.plaza_nombre)
            end
          
            it "and should have the same estado nombre" do
              @concepto_A.servicio.plaza.estado.nombre.should be_eql(@concepto_clon.servicio_clon.estado_nombre)
            end
          
            it "and should have the same metasubservicio nombre" do
              @concepto_A.servicio.metasubservicio.nombre.should be_eql(@concepto_clon.servicio_clon.metasubservicio_nombre)
            end
          
            it "and should have the same metaservicio nombre" do
              @concepto_A.servicio.metasubservicio.metaservicio.nombre.should be_eql(@concepto_clon.servicio_clon.metaservicio_nombre)
            end
          end
        end
      
        context "both (concepto_B and second concepto) should have" do
          before(:each) do
            ActiveRecord::Base.connection.execute "select clona_recurso('servicios', #{@servicio.id},0);"
            @servicio_clon = ServicioClon.first
            # @concepto_B was inserted last
          end
        
          it "the same disponibilidad" do
            @concepto_B.disponible.should be_eql(@servicio_clon.concepto_clones.last.disponible)
          end
        
          it "the same costo" do
            @concepto_B.costo.should be_eql(@servicio_clon.concepto_clones.last.costo)
          end
        
          it "the same valor" do
            @concepto_B.valor.should be_eql(@servicio_clon.concepto_clones.last.valor)
          end
        
          it "the same comentarios" do
            @concepto_B.comentarios.should be_eql(@servicio_clon.concepto_clones.last.comentarios)
          end
        
          it "the same metaconcepto nombre" do
            @concepto_B.metaconcepto.nombre.should be_eql(@servicio_clon.concepto_clones.last.metaconcepto_nombre)
          end
        
          it "the same metaconcepto tipo" do
            @concepto_B.metaconcepto.tipo.should be_eql(@servicio_clon.concepto_clones.last.metaconcepto_tipo)
          end
        
          context "the same servicio data clone" do
            before(:each) do
              @concepto_clon = ConceptoClon.last
            end
          
            it "and should have the same plaza nombre" do
              @concepto_B.servicio.plaza.nombre.should be_eql(@concepto_clon.servicio_clon.plaza_nombre)
            end
          
            it "and should have the same estado nombre" do
              @concepto_B.servicio.plaza.estado.nombre.should be_eql(@concepto_clon.servicio_clon.estado_nombre)
            end
          
            it "and should have the same metasubservicio nombre" do
              @concepto_B.servicio.metasubservicio.nombre.should be_eql(@concepto_clon.servicio_clon.metasubservicio_nombre)
            end
          
            it "and should have the same metaservicio nombre" do
              @concepto_B.servicio.metasubservicio.metaservicio.nombre.should be_eql(@concepto_clon.servicio_clon.metaservicio_nombre)
            end
          end
        end
      
      end
    
    end
  end
  
  context "on paquetes" do
    
    context "doble play" do
      before(:each) do
        @paquete = Factory.create(:paquete_doble_play)
        @id_paquete = ActiveRecord::Base.connection.select_value "select clona_recurso('paquetes', #{@paquete.id},0)"
      end
      
      it "should create a clone registro of type PaqueteClon with the same costo_1_10 as original Paquete" do
        @paquete.costo_1_10.should be_eql(PaqueteClon.first.costo_1_10)
      end
      
      it "should create a clone registro of type PaqueteClon with the same costo_11_31 as original Paquete" do
        @paquete.costo_11_31.should be_eql(PaqueteClon.first.costo_11_31)
      end
      
      it "should create a clone registro of type PaqueteClon with the same costo_real as original Paquete" do
        @paquete.costo_real.should be_eql(PaqueteClon.first.costo_real)
      end
      
      it "should create a clone registro of type PaqueteClon with the same ahorro as original Paquete" do
        @paquete.ahorro.should be_eql(PaqueteClon.first.ahorro)
      end
      
      it "should create a clone registro of type PaqueteClon with the same numero_de_servicios as original Paquete" do
        @paquete.numero_de_servicios.should be_eql(PaqueteClon.first.numero_de_servicios)
      end
      
      it "should create a clone registro of type PaqueteClon with the same television as original Paquete" do
        @paquete.television.should be_eql(PaqueteClon.first.television)
      end
      
      it "should create a clone registro of type PaqueteClon with the same telefonia as original Paquete" do
        @paquete.telefonia.should be_eql(PaqueteClon.first.telefonia)
      end
      
      it "should create a clone registro of type PaqueteClon with the same internet as original Paquete" do
        @paquete.internet.should be_eql(PaqueteClon.first.internet)
      end
      
      it "should create a clone registro of type PaqueteClon with the same plaza nombre as original Paquete" do
        @paquete.plaza.nombre.should be_eql(PaqueteClon.first.plaza_nombre)
      end
      
      it "should create a clone registro of type PaqueteClon with the same plaza-estado nombre as original Paquete" do
        @paquete.plaza.estado.nombre.should be_eql(PaqueteClon.first.estado_nombre)
      end
      
      it "should create a clone registro of type PaqueteClon with the same zona as original Paquete" do
        @paquete.zona.nombre.should be_eql(PaqueteClon.first.zona_nombre)
      end
      
    end
    
    
  end
end