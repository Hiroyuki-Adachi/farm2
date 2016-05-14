require 'rubygems'
require 'bundler/setup'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

ENV["RAILS_ENV"] = "test"
module Rails
  def self.env
    ActiveSupport::StringInquirer.new("test")
  end
end

require 'rails/all'
require 'mongoid'
require 'mongo_mapper'
require 'shoulda'
require 'rr'
require 'rails/test_help'
require 'rails4-autocomplete'

module Rails4Autocomplete
  class Application < ::Rails::Application
  end
end

Rails4Autocomplete::Application.routes.draw do
  match '/:controller(/:action(/:id))'
end

ActionController::Base.send :include, Rails4Autocomplete::Application.routes.url_helpers

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
end

