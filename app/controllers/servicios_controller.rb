class ServiciosController < ApplicationController
  
  before_filter :only => [:some] do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 podrán ejecutar la acción definida
    # en "only"
    controller.nivel_logged_in(["nivel 1"])
  end
  
  before_filter :only => [:new, :create, :edit, :update, :destroy, :update_conceptos, :separar_objetos] do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 y 2 podrán ejecutar las acciones
    # definidas en "only"
    controller.nivel_logged_in(["nivel 1", "nivel 2"])
  end
  
  # GET /servicios/new
  # GET /servicios/new.xml
  def new
    @plaza = current_user.responsabilidad
    @metaservicios = Metaservicio.all
    super
  end

  def create
    @servicio = Servicio.new(params[:servicio])
    params[:conceptos].each_value { |concepto| @servicio.conceptos.build(concepto) } if params.has_key?(:conceptos)
    
    respond_to do |format|
      format.js do
        if @servicio.save
          render :update do |page|
            page['servicios'].replace_html :partial => 'administraciones/index_modelo_barra', 
                                                          :locals => {:modelo => 'servicio'}
            page['servicios'].visual_effect :appear
          end
        else
          @errores=@servicio.errors.inject({}) { |h, par| (h[par.first] || h[par.first] = String.new) << "#{par.last}, " ; h }
          render :update do |page|    
            page["errores_servicio"].replace_html :partial => "compartidos/errores_modelo", 
                                                :locals => {:modelo => "servicio"} 
            page["errores_servicio"].appear                                    
            page["errores_servicio"].visual_effect :highlight, :startcolor => "#AB0B00", :endcolor => "#E6CFD1"  
          end
        end
      end
    end
  end

  # GET /servicios/1/edit
  def edit
    @plaza = current_user.responsabilidad
    @metaservicios = Metaservicio.all
    @servicio= Servicio.find(params[:id].gsub(/\D/,''))
    metaservicio = @servicio.metasubservicio.metaservicio
    @metasubservicios = metaservicio.metasubservicios
    @from_edit="EDIT"
    super
  end
  
  def update
    @servicio = Servicio.find(params[:id].gsub(/\D/,''))
    if params.has_key?(:conceptos)
      params[:conceptos].each_key do |concepto_key| 
        @servicio.conceptos.find(concepto_key).update_attributes(params[:conceptos]["#{concepto_key}"]) 
      end
    end
    
    respond_to do |format|
      format.js do
        if @servicio.update_attributes(params[:servicio])
          render :update do |page|
            page['servicios'].replace_html :partial => 'administraciones/index_modelo_barra', 
                                           :locals => {:modelo => 'servicio'}
            page['servicios'].visual_effect :appear
          end
        else
          @errores=@servicio.errors.inject({}) { |h, par| (h[par.first] || h[par.first] = String.new) << "#{par.last}, " ; h }
          render :update do |page|    
            page["errores_servicio"].replace_html :partial => "compartidos/errores_modelo", 
                                                  :locals => {:modelo => "servicio"} 
            page["errores_servicio"].appear                                    
            page["errores_servicio"].visual_effect :highlight, :startcolor => "#AB0B00", :endcolor => "#E6CFD1"  
          end
        end
      end
    end
  end
  
  def listing
    plaza= Plaza.find(params[:plaza_id])
    @objetos = plaza.servicios
    
    respond_to do |format|
       format.js do
         render :update do |page|
           page['servicios'].replace_html :partial => "compartidos/listing_modelo", 
                                              :locals => {:modelo => 'servicio'}
           page['servicios'].visual_effect :appear
           page << "Nifty('div#servicios');"
         end
       end
    end
  end
  
  def cambios_de_div
    if params[:id].blank?
      respond_to do |format|
        format.js do
          render :update do |page|
            page["conceptos_forma"].visual_effect :fade
            page["metasubservicio_forma"].visual_effect :fade
          end
        end
      end
    else
      @metaservicio = Metaservicio.find(params[:id].gsub(/\D/,''))
      @metaconceptos = @metaservicio.metaconceptos
      @servicio = Servicio.new
      @metaconceptos.size.times { @servicio.conceptos.build }
      metasubservicios = @metaservicio.metasubservicios
      respond_to do |format|
        format.js do
          render :update do |page|
            page["conceptos_forma"].replace_html :partial => "conceptos_forma"
            page["conceptos_forma"].visual_effect :appear
            page["metasubservicio_forma"].replace_html :partial => "metasubservicio_forma", 
                                                       :locals => { :metasubservicios => metasubservicios }
            page["metasubservicio_forma"].visual_effect :appear
          end
        end
      end
    end
  end
  
  def detalles_asociados
    servicio_id=params[:id]
    accion=params[:accion]
    @servicio = Servicio.find(servicio_id)
    @conceptos = @servicio.conceptos
    
    respond_to do |format|
      format.js do
        render :update do |page|
          if accion.eql?("mostrar")
            page["servicio_show_#{servicio_id}"].replace_html :partial => "servicio_show"
            page["servicio_show_#{servicio_id}"].visual_effect :appear
          elsif accion.eql?("esconder")
            page["servicio_show_#{servicio_id}"].visual_effect :fade
          end
        end
      end
    end
  end
  
end
