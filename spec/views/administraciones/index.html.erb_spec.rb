require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/administraciones/index" do
  before(:each) do
    assigns[:modelos] = ["estado"]
  end
  
  describe "actions for model estado" do
    
    it "should render partial _new_estado on action new" do
      re new_estado_path
      template.should_receive(:render).with(:partial => 'new_estado').and_return('rendered from partial')    
    end
  end
  

end