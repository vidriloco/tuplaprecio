class ServiciosController < ApplicationController
  
  before_filter :only => [:new, :create, :edit, :update, :destroy] do |controller|
    controller.usuario_es?(:encargado)
  end
  
  before_filter :exporta_usuario_actual, :only => [:create, :update, :destroy]
  
  # GET /servicios/new
  # GET /servicios/new.xml
  def new
    @plaza = current_user.plaza
    @metaservicios = Metaservicio.all
    super
  end

  def create
    @servicio = Servicio.new(params[:servicio])
    params[:conceptos].each_value { |concepto| @servicio.conceptos.build(concepto) } if params.has_key?(:conceptos)
    @plaza = current_user.plaza
    
    respond_to do |format|
      format.js do
        if @servicio.save
          render :update do |page|
            page['servicios'].replace_html :partial => 'tableros/index_modelo_barra', :locals => {:modelo => 'servicio'}
            page['servicios'].visual_effect :appear
            page << "Nifty('#servicios');"                                      
          end
        else
          @errores=@servicio.errors.inject({}) { |h, par| (h[par.first] || h[par.first] = String.new) << "#{par.last}, " ; h }
          render :update do |page|    
            page["errores_servicio"].replace_html :partial => "compartidos/errores_modelo", 
                                                :locals => {:modelo => "servicio"}
            page << "Nifty('#errores_servicio h3', 'top');"                                      
            page["errores_servicio"].appear                                    
            page["errores_servicio"].visual_effect :highlight, :startcolor => "#AB0B00", :endcolor => "#E6CFD1"  
          end
        end
      end
    end
  end

  # GET /servicios/1/edit
  def edit
    @plaza = current_user.plaza
    @metaservicios = Metaservicio.all
    @servicio= Servicio.find(params[:id].gsub(/\D/,''), :include => [{:metasubservicio => {:metaservicio => :metaconceptos}}, :conceptos])
    
    # Trata el caso en el que se hayan añadido más metaconceptos al metaservicio.
    # Averigua cuál es la diferencia entre los metaconceptos del metaservicio y la instancia del servicio ligado al metaservicio,
    # después actualiza los conceptos del servicio.
    metaconceptos=@servicio.metasubservicio.metaservicio.metaconceptos.size
    conceptos = @servicio.conceptos.size
    if conceptos < metaconceptos
      metaconceptos_agregables=@servicio.metasubservicio.metaservicio.metaconceptos.last(metaconceptos-conceptos) 
      metaconceptos_agregables.each do |mc|
        concepto = Concepto.create
        concepto.metaconcepto=mc
        @servicio.conceptos << concepto
      end
    end
    @servicio.save
    @metasubservicios = @servicio.metasubservicio.metaservicio.metasubservicios
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
            page['servicios'].replace_html :partial => 'tableros/index_modelo_barra', 
                                           :locals => {:modelo => 'servicio'}
            page['servicios'].visual_effect :appear
            page << "Nifty('div#servicios');"
          end
        else
          @errores=@servicio.errors.inject({}) { |h, par| (h[par.first] || h[par.first] = String.new) << "#{par.last}, " ; h }
          render :update do |page|    
            page["errores_servicio"].replace_html :partial => "compartidos/errores_modelo", 
                                                  :locals => {:modelo => "servicio"} 
            page << "Nifty('#errores_servicio h3', 'top');"                                      
            page["errores_servicio"].appear                                    
            page["errores_servicio"].visual_effect :highlight, :startcolor => "#AB0B00", :endcolor => "#E6CFD1"  
          end
        end
      end
    end
  end
  
  def listing
    @plaza = current_user.plaza
    @objetos = @plaza.servicios
    
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
  
  def destroy
    super do
      render :update do |page|
         if current_user.plaza.servicios.count == 0
           page["servicios"].replace_html :partial => "tableros/index_modelo_barra", 
                                               :locals => {:modelo => "servicio"}
           page["servicios"].visual_effect :appear
           page << "Nifty('div#servicios');"
         else   
           page["servicio_#{params[:id]}"].visual_effect :fade
         end
       end
    end
  end
  
  def listing
    @objetos = current_user.plaza.servicios
    render :update do |page|
      page["servicios"].replace_html :partial => "compartidos/listing_modelos_encargado", 
                                         :locals => {:modelo => "servicio"}
      page["servicios"].visual_effect :appear
      page << "Nifty('div#servicios');"
    end
  end
  
  private
    def exporta_usuario_actual
      Thread.current['usuario'] = current_user.id
    end
  
end
