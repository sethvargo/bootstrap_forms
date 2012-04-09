module BootstrapForms
  class Engine < ::Rails::Engine
    initializer 'bootstrap_forms.initialize' do
      config.to_prepare do
        ActiveSupport.on_load(:action_view) do
          include BootstrapForms::Helpers::FormHelper
          include BootstrapForms::Helpers::FormTagHelper
          
          # Do not wrap errors in the extra div
          ::ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
            html_tag
          end
        end
      end
    end
  end
end