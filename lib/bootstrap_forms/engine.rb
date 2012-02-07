module BootstrapForms
  class Engine < ::Rails::Engine
    config.after_initialize do |app|
      require 'bootstrap_forms/initializer'
    end
  end
end