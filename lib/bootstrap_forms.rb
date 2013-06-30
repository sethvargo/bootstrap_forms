# encoding: utf-8
require 'bootstrap_forms/engine' if defined?(::Rails)

module BootstrapForms
  require_relative 'bootstrap_forms/engine'
  require_relative 'bootstrap_forms/form_builder'
  require_relative 'bootstrap_forms/version'

  class << self
    def default_form_builder
      @default_form_builder ||= BootstrapForms::FormBuilder
    end

    def default_form_builder=(builder)
      @default_form_builder = builder
    end
  end
end
