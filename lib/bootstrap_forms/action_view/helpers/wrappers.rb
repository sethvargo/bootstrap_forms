module BootstrapForms
  module Helpers
    module Wrappers
      private
      def control_group_div(&block)
        field_errors = error_string
        if @field_options[:error] 
          (@field_options[:error] << ", " << field_errors) if field_errors
        else
          @field_options[:error] = field_errors
        end

        klasses = ['control-group']
        klasses << 'error' if @field_options[:error]
        klasses << 'success' if @field_options[:success]
        klasses << 'warning' if @field_options[:warning]
        klass = klasses.join(' ')

        content_tag(:div, :class => klass, &block)
      end

      def error_string
        errors = object.errors[@name]
        if errors.present?
          errors.map { |e|
            "#{@options[:label] || human_attribute_name} #{e}"
          }.join(", ")
        end
      end

      def human_attribute_name
        object.class.human_attribute_name(@name)
      end

      def input_div(&block)
        content_tag(:div, :class => 'controls') do
          if @field_options[:append] || @field_options[:prepend]
            klass = 'input-prepend' if @field_options[:prepend]
            klass = 'input-append' if @field_options[:append]
            content_tag(:div, :class => klass, &block)
          else
            yield if block_given?
          end
        end
      end

      def label_field(&block)
        label(@name, block_given? ? block : @field_options[:label], :class => ['control-label', required_class].compact.join(' '))
      end

      def required_class
        return 'required' if @field_options[:required] || object.class.validators_on(@name).any? { |v| v.kind_of? ActiveModel::Validations::PresenceValidator }
        nil
      end

      %w(help_inline error success warning help_block append prepend).each do |method_name|
        define_method(method_name) do |*args|
          return '' unless value = @field_options[method_name.to_sym]
          case method_name
          when 'help_block'
            element = :p
            klass = 'help-block'
          when 'append', 'prepend'
            element = :span
            klass = 'add-on'
          else
            element = :span
            klass = 'help-inline'
          end
          content_tag(element, value, :class => klass)
        end
      end

      def extras(&block)
        [prepend, (yield if block_given?), append, help_inline, error, success, warning, help_block].join('').html_safe
      end

      def objectify_options(options)
        super.except(:label, :help_inline, :error, :success, :warning, :help_block, :prepend, :append)
      end
    end
  end
end