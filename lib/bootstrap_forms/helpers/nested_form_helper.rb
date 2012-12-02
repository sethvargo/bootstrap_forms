begin
  require 'nested_form/builder_mixin'

  module NestedForm
    class TwitterBootstrapBuilder < ::BootstrapForms::FormBuilder
      include ::NestedForm::BuilderMixin
    end
  end

  module BootstrapForms
    module Helpers
      module NestedFormHelper
        def bootstrap_nested_form_for(*args, &block)
          options = args.extract_options!.reverse_merge(:builder => NestedForm::TwitterBootstrapBuilder)
          form_for(*(args << options), &block) << after_nested_form_callbacks
        end
      end
    end
  end
rescue LoadError => e
  module BootstrapForms
    module Helpers
      module NestedFormHelper
        def bootstrap_nested_form_for(*args, &block)
          raise 'nested_form was not found. Is it in your Gemfile?'
        end
      end
    end
  end
end
