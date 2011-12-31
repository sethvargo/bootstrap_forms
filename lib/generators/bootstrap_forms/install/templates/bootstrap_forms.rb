module ActionView
  module Helpers
    module FormHelper
      def form_for_with_bootstrap(record, options = {}, &proc)
        options[:builder] = BootstrapFormBuilder
        form_for_without_bootstrap(record, options, &proc)
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