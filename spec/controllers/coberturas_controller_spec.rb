require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CoberturasController do

  def mock_cobertura(stubs={})
    @mock_cobertura ||= mock_model(Cobertura, stubs)
  end

  describe "GET index" do
    it "assigns all coberturas as @coberturas" do
      Cobertura.stub!(:find).with(:all).and_return([mock_cobertura])
      get :index
      assigns[:coberturas].should == [mock_cobertura]
    end
  end

  describe "GET show" do
    it "assigns the requested cobertura as @cobertura" do
      Cobertura.stub!(:find).with("37").and_return(mock_cobertura)
      get :show, :id => "37"
      assigns[:cobertura].should equal(mock_cobertura)
    end
  end

  describe "GET new" do
    it "assigns a new cobertura as @cobertura" do
      Cobertura.stub!(:new).and_return(mock_cobertura)
      get :new
      assigns[:cobertura].should equal(mock_cobertura)
    end
  end

  describe "GET edit" do
    it "assigns the requested cobertura as @cobertura" do
      Cobertura.stub!(:find).with("37").and_return(mock_cobertura)
      get :edit, :id => "37"
      assigns[:cobertura].should equal(mock_cobertura)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created cobertura as @cobertura" do
        Cobertura.stub!(:new).with({'these' => 'params'}).and_return(mock_cobertura(:save => true))
        post :create, :cobertura => {:these => 'params'}
        assigns[:cobertura].should equal(mock_cobertura)
      end

      it "redirects to the created cobertura" do
        Cobertura.stub!(:new).and_return(mock_cobertura(:save => true))
        post :create, :cobertura => {}
        response.should redirect_to(cobertura_url(mock_cobertura))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved cobertura as @cobertura" do
        Cobertura.stub!(:new).with({'these' => 'params'}).and_return(mock_cobertura(:save => false))
        post :create, :cobertura => {:these => 'params'}
        assigns[:cobertura].should equal(mock_cobertura)
      end

      it "re-renders the 'new' template" do
        Cobertura.stub!(:new).and_return(mock_cobertura(:save => false))
        post :create, :cobertura => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested cobertura" do
        Cobertura.should_receive(:find).with("37").and_return(mock_cobertura)
        mock_cobertura.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :cobertura => {:these => 'params'}
      end

      it "assigns the requested cobertura as @cobertura" do
        Cobertura.stub!(:find).and_return(mock_cobertura(:update_attributes => true))
        put :update, :id => "1"
        assigns[:cobertura].should equal(mock_cobertura)
      end

      it "redirects to the cobertura" do
        Cobertura.stub!(:find).and_return(mock_cobertura(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(cobertura_url(mock_cobertura))
      end
    end

    describe "with invalid params" do
      it "updates the requested cobertura" do
        Cobertura.should_receive(:find).with("37").and_return(mock_cobertura)
        mock_cobertura.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :cobertura => {:these => 'params'}
      end

      it "assigns the cobertura as @cobertura" do
        Cobertura.stub!(:find).and_return(mock_cobertura(:update_attributes => false))
        put :update, :id => "1"
        assigns[:cobertura].should equal(mock_cobertura)
      end

      it "re-renders the 'edit' template" do
        Cobertura.stub!(:find).and_return(mock_cobertura(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested cobertura" do
      Cobertura.should_receive(:find).with("37").and_return(mock_cobertura)
      mock_cobertura.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the coberturas list" do
      Cobertura.stub!(:find).and_return(mock_cobertura(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(coberturas_url)
    end
  end

end
