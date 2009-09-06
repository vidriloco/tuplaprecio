require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CoberturasController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "coberturas", :action => "index").should == "/coberturas"
    end

    it "maps #new" do
      route_for(:controller => "coberturas", :action => "new").should == "/coberturas/new"
    end

    it "maps #show" do
      route_for(:controller => "coberturas", :action => "show", :id => "1").should == "/coberturas/1"
    end

    it "maps #edit" do
      route_for(:controller => "coberturas", :action => "edit", :id => "1").should == "/coberturas/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "coberturas", :action => "create").should == {:path => "/coberturas", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "coberturas", :action => "update", :id => "1").should == {:path =>"/coberturas/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "coberturas", :action => "destroy", :id => "1").should == {:path =>"/coberturas/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/coberturas").should == {:controller => "coberturas", :action => "index"}
    end

    it "generates params for #new" do
      params_from(:get, "/coberturas/new").should == {:controller => "coberturas", :action => "new"}
    end

    it "generates params for #create" do
      params_from(:post, "/coberturas").should == {:controller => "coberturas", :action => "create"}
    end

    it "generates params for #show" do
      params_from(:get, "/coberturas/1").should == {:controller => "coberturas", :action => "show", :id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/coberturas/1/edit").should == {:controller => "coberturas", :action => "edit", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/coberturas/1").should == {:controller => "coberturas", :action => "update", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/coberturas/1").should == {:controller => "coberturas", :action => "destroy", :id => "1"}
    end
  end
end
