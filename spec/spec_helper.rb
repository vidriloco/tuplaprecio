# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'spec/autorun'
require 'spec/rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

require 'factory_girl'
Dir.glob("#{RAILS_ROOT}/factories/*.rb").each {|f| require f }

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  #
  # For more information take a look at Spec::Runner::Configuration and Spec::Runner
end

shared_examples_for "admin only" do
    
  it "should not be accessible without authentication" do
    current_user = nil

    send @method, @action, @params

    response.should redirect_to(new_sesion_url)
  end

  it "should not be accessible by an encargado user" do
    current_user = Factory.stub(:usuario_completo_encargado)

    send @method, @action, @params

    response.should redirect_to(new_sesion_url)
  end

  it "should not be accessible by an agente user" do
    current_user = Factory.stub(:usuario_completo_agente)

    send @method, @action, @params

    response.should redirect_to(new_sesion_url)
  end

  it "should be accessible by an admin user" do
    current_user = Factory.stub(:usuario_completo_admin)
    @controller.stub!(:logged_in?).and_return(true)
    @controller.stub!(:nivel_logged_in).with(["nivel 1"]).and_return(current_user)
    send @method, @action, @params

    response.should_not redirect_to(new_sesion_url)
  end
end

#Filters helper spec methods from http://www.elctech.com/tutorials/spec-ing-before-filters-in-rails

module Spec
  module Rails
    module Filters

      def before_filter(name)
        self.class.before_filter.detect { |f| f.method == name }
      end
      
      def run_filter(filter_method, params={})
        self.params = params
        instance_eval filter_method.to_s
      end
      
      def before_filters
        return self.class.before_filter.collect { |f| f.method }
      end

    end
    
    module BeforeFilters
      
      def has_options?(expected_options)
        expected_options.each do |key, values|
          expected_options[key] = Array(values).map(&:to_s).to_set
        end
        
        options == expected_options
      end
      
    end
    
  end
end

ActionController::Base.send(:include, Spec::Rails::Filters) 
ActionController::Filters::BeforeFilter.send(:include, Spec::Rails::BeforeFilters)

