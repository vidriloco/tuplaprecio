require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LogsController do

  before(:each) do
    request.env["HTTP_REFERER"] = sesiones_path
  end

  it "should not let an encargado usuario to access it's actions" do
      usuario = Factory.create(:usuario_completo_encargado)
      controller.stub!(:current_user).and_return usuario
      get :index
      response.should redirect_to(sesiones_path)
  end

  it "should not let an agente usuario to access it's actions" do
      usuario = Factory.create(:usuario_completo_agente)
      controller.stub!(:current_user).and_return usuario
      get :index
      response.should redirect_to(sesiones_path)
  end
  
  context "actions executed when admin" do
  
  before(:each) do
    @usuario = Factory.create(:usuario_completo_admin)
    controller.stub!(:current_user).and_return @usuario
  end
  
    it "should let an admin usuario access it's actions'" do
      get :index
      response.should render_template("index")
    end
  
    it "should find the current logs on index action" do
      @logs = Log.find(:all)
      Log.should_receive(:find).and_return(@logs)
      get :index
    end
  
    context "on destroy action" do
      
      before(:each) do
        Thread.current['usuario'] = @usuario
        @log = Factory.create(:log_servicio)
      end
      
      it "should find the log to be destroyed" do
        Log.should_receive(:find).with(@log.id.to_s).and_return(@log)
        delete :destroy, :id => @log.id
      end
  
      it "should destroy the log" do
        lambda {
          delete :destroy, :id => @log.id
        }.should change {  Log.count }
      end
    end
  
  end
end
