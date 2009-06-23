require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EstadosController do

  describe "GET/new action" do

      before :each do
        @action = :new
        @method = :get
        Estado.stub!(:new).and_return(@estado = mock_model(Estado))
      end
      
      #it_should_behave_like "admin only"
      
      it "should success" do
        get :new
        response.should be_success
      end  
        
      it "should generate a new instance" do
        get :new
        assigns[:estado].should be_equal(@estado)
      end
    
      it "should successfuly replace html id" do
        get :new
        response.should have_rjs(:chained_replace_html, 'estados','new_estado')
      end
    
  end

  describe "other" do
    
  end

end