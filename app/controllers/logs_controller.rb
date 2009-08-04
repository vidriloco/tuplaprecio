class LogsController < ApplicationController
  
  before_filter do |controller|
    controller.usuario_es?(:administrador)
  end
  
  def index
    @logs = Log.paginate(:all, :page => params[:page], :per_page => 3)
    
    respond_to do |format|
      format.html
      format.js {
        render :update do |page|
          page.replace_html 'log_records_list', :partial => 'log_records_list'
        end
      }
    end
    
  end
  
  def destroy
    super do
      render :update do |page|
         if Log.count == 0
           page['log_records'].replace_html :partial => "no_hay_log_records"
           page['log_records'].visual_effect :appear
         else   
           page["log_#{params[:id]}"].visual_effect :fade
         end
       end
    end
  end
  
  def show
    log=Log.find(params[:id])
    @objeto_type=log.recurso_type
    @objeto=log.recurso
    
    render :partial => 'recurso_detalles'
  end
  
  def log_a_session
    if session['logs'].nil?
      session['logs'] = Array.new
    end
    
    if session['logs'].index(params[:id]).nil?
      session['logs'] << params[:id]
    else
      session['logs'].delete_at(session['logs'].index(params[:id]))  
    end
    render(:nothing => true)
  end
  
  def logs_a_pdf
    @logs = session['logs'].map {|log_id| Log.find(log_id)}
    
    pdf_doc = Utilidades.genera_pdf_log(render_to_string(:partial => 'logs_a_pdf'))
    send_data pdf_doc, :filename => "registros_acciones.pdf", :disposition => 'attachment', :type => :pdf
    
  end
end
