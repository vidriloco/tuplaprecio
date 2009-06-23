require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MetaconceptosController do


  describe 'GET/show action' do
    
    before :each do
      @method = :get
      @action = :show
      Metaconcepto.stub!(:new).and_return(@metaconcepto = mock_model(Metaconcepto, :id => 1))
      Metaconcepto.stub!(:find).and_return(@metaconcepto)
    end
    
    it "should call the metaconcepto action succesfully" do
      get :show, :id => 1
      response.should be_success
    end
    
    it "should find the metaconcepto" do
      Metaconcepto.should_receive(:find).with("1").and_return(@metaconcepto)
      get :show, :id => 1
    end
    
    it "should render Metaconcepto show page" do
      get :show, :id => 1
      response.should render_template("show")
    end
    
    it "should retrieve the object to be shown" do
      get "show", :id => 1
      assigns[:metaconcepto].should be_equal(@metaconcepto)
    end
  end
  
  describe "PUT/update action" do
    
    before :each do
      @method = :put
      @action = :update
    end
    
    describe "with valid attributes" do
      
      before :each do
        Metaconcepto.stub!(:new).and_return(@metaconcepto = mock_model(Metaconcepto, :id => 1, :update_attributes => true))
        Metaconcepto.stub!(:find).and_return(@metaconcepto)
      end
      
      it "should retrieve the correct metaconcepto based on it's ID" do
        Metaconcepto.should_receive(:find).with("1").and_return(@metaconcepto)
        put :update, :id => 1
      end
      
      it "should have found metaconcepto instance" do
        put :update, :id => 1
        assigns(:metaconcepto).should be_instance_of(Metaconcepto)
      end
      
      it "should correctly change attributes" do
        @metaconcepto.should_receive(:update_attributes).and_return(true)
        put :update, :id => 1, :metaconcepto => {}
      end
      
      it "should redirect_to metaconcepto show page" do
        @metaconcepto.stub!(:update_attributes).and_return(true)
        put :update, :id => 1, :metaconcepto => {}
        response.should redirect_to("metaconceptos/1")
      end
      
    end
  end
  
  describe "e" do
    
    it "should an ID and then render Metaconcepto edit page"
  
    it "should render Metaconcepto new page" do
      Metaconcepto.should_receive(:new).and_return(@metaconcepto)
      get :new
      response.should render_template("new")
    end
  
    it "should render the Metaconcepto index action" do
      get :index
      response.should render_template("index")
    end
  
  end
  

  describe 'handling of DELETE actions' do
  
    it "should succesfully delete a Metaconcepto given it's ID"
  
  end

  
  describe "POST/create action" do
    
    before :each do
      @method = :post
      @action = :create
      @params = {:nombre => "Metaconcepto cualquiera", :tipo => "A"}
    end
    
    describe "with valid input" do
      before :each do
        Metaconcepto.stub!(:new).and_return(@metaconcepto = mock_model(Metaconcepto, :save => true))
      end
    
      it "should create the Metaconcepto instance" do
        Metaconcepto.should_receive(:new).with(any_args()).and_return(@metaconcepto)
        post :create, :metaconcepto => @params
      end
  
      it "should save the Metaconcepto instance" do
        @metaconcepto.should_receive(:save).with(no_args()).and_return(true)
        post :create, :metaconcepto => @params
      end
    
      it "should be a redirect" do
        post :create, :metaconcepto => @params
        response.should be_redirect
      end
    
      it "should get redirected to the Metaconcepto model list page" do
        post :create, :metaconcepto => @params
        response.should redirect_to(metaconcepto_path(@metaconcepto))
      end
    
      it "should assign Metaconcepto instance" do
        post :create, :metaconcepto => @params
        assigns(:metaconcepto).should be_equal(@metaconcepto)
      end
    end
    
    describe "with invalid input" do
  
      before :each do
        Metaconcepto.stub!(:new).and_return(@metaconcepto = mock_model(Metaconcepto, :save => false))
      end
      
      it "should not save the instance" do
        @metaconcepto.should_receive(:save).with(no_args()).and_return(false)
        post :create, :metaconcepto => @params
      end
      
      it "should re-render new form" do
        post :create, :metaconcepto => @params
        response.should render_template("new")
      end
      
    end
  end

  describe "handling of PUT actions" do

    it "should succesfully update a Metaconcepto given it's ID and update attributes with values"

  end

end
