# encoding: utf-8
require 'bootstrap_forms/engine' if defined?(::Rails)

module BootstrapForms
  extend ActiveSupport::Autoload

  autoload :FormBuilder
  autoload :Helpers
end