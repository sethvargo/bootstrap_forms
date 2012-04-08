module BootstrapForms
  class Engine < ::Rails::Engine
    config.after_initialize do |app|
      require 'bootstrap_forms/action_view/helpers/wrappers'
      require 'bootstrap_forms/action_view/helpers/form_helper'
      require 'bootstrap_forms/action_view/helpers/form_tag_helper'
      
      include ::ActionView::Helpers::FormHelper
      include ::ActionView::Helpers::FormTagHelper

      # don't wrap in those special divs
      ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
        html_tag
      end
    end
  end
end