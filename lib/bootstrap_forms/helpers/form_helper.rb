module BootstrapForms
  module Helpers
    module FormHelper
      def bootstrap_form_for(record, options = {}, &block)
        options[:builder] ||= BootstrapForms.default_form_builder

        form_options = options.deep_dup
        options[:summary_errors] = true unless form_options.has_key?(:summary_errors)
        form_options.delete(:summary_errors)

        form_for(record, form_options) do |f|
          if f.object.respond_to?(:errors) and options[:summary_errors]
            f.error_messages.html_safe + capture(f, &block).html_safe
          else
            capture(f, &block).html_safe
          end
        end
      end

      def bootstrap_fields_for(record_name, record_object = nil, options = {}, &block)
        options[:builder] ||= BootstrapForms.default_form_builder

        fields_for(record_name, record_object, options, &block)
      end
    end
  end
end
