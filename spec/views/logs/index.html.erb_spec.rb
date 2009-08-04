require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/logs/index" do
  before(:each) do
    @logs = Log.stub!(:all)
  end

  #Delete this example and add some real ones or delete this file
  it "should assign @logs variable" do
    render 'logs/index'
  end
end
