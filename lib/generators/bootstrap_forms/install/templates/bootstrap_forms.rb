module ActionView
  module Helpers
    module FormHelper
      def form_for_with_bootstrap(record, options = {}, &block)
        options[:builder] = BootstrapFormBuilder
        form_for_without_bootstrap(record, options) do |f|
          f.error_messages.html_safe + capture(f, &block).html_safe
        end
      end
      
      def fields_for_with_bootstrap(record_name, record_object = nil, options = {}, &block)
        options[:builder] = BootstrapFormBuilder
        fields_for_without_bootstrap(record_name, record_object, options, &block)
      end
      
      alias_method_chain :form_for, :bootstrap
      alias_method_chain :fields_for, :bootstrap
    end
  end
end

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
  html_tag
end