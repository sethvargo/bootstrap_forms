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

        klasses = []
        klasses << 'control-group' unless @field_options[:control_group] == false
        klasses << 'error' if @field_options[:error]
        klasses << 'success' if @field_options[:success]
        klasses << 'warning' if @field_options[:warning]
        
        control_group_options = {}
        control_group_options[:class] = klasses if !klasses.empty?

        content_tag(:div, control_group_options, &block)
      end

      def error_string
        if respond_to?(:object) and object.respond_to?(:errors)
          errors = object.errors[@name]
          if errors.present?
            errors.map { |e|
              "#{@options[:label] || human_attribute_name} #{e}"
            }.join(", ")
          end
        end
      end

      def human_attribute_name
        object.class.human_attribute_name(@name) rescue @name.titleize
      end

      def input_div(&block)
        content_options = {}
        content_options[:class] = 'controls' 
        if @field_options[:control_group] == false
          @field_options.delete :control_group
          write_input_div(&block)
        else
          content_tag(:div, :class => 'controls') do
            write_input_div(&block)
          end
        end
      end
      
      def write_input_div(&block)
        if @field_options[:append] || @field_options[:prepend] || @field_options[:append_button]
          klass = []
          klass << 'input-prepend' if @field_options[:prepend]
          klass << 'input-append' if @field_options[:append] || @field_options[:append_button]
          content_tag(:div, :class => klass, &block)
        else
          yield if block_given?
        end
      end

      def label_field(&block)
        if @field_options[:label] == '' || @field_options[:label] == false
          return ''.html_safe
        else
          label_options = {}
          label_options[:class] = 'control-label' unless @field_options[:control_group] == false
          if respond_to?(:object)
             label(@name, block_given? ? block : @field_options[:label], label_options)
           else
             label_tag(@name, block_given? ? block : @field_options[:label], label_options)
           end
        end
      end

      def required_attribute
        if respond_to?(:object) and object.respond_to?(:errors) and object.class.respond_to?('validators_on')
          return { :required => true } if object.class.validators_on(@name).any? { |v| v.kind_of? ActiveModel::Validations::PresenceValidator }
        end
        {}
      end

      %w(help_inline error success warning help_block append append_button prepend).each do |method_name|
        define_method(method_name) do |*args|
          return '' unless value = @field_options[method_name.to_sym]
          
          escape = true
          tag_options = {}
          case method_name
          when 'help_block'
            element = :p
            tag_options[:class] = 'help-block'
          when 'append', 'prepend'
            element = :span
            tag_options[:class] = 'add-on'
          when 'append_button'
            element = :button
            button_options = value
            value = ''
            
            if button_options.has_key? :icon
              value << content_tag(:i, '', { :class => button_options.delete(:icon) })
              value << ' '
              escape = false
            end
            
            value << button_options.delete(:label)
            
            tag_options[:type] = 'button'
            tag_options[:class] = 'btn'
            tag_options.merge! button_options
          else
            element = :span
            tag_options[:class] = 'help-inline'
          end
          content_tag(element, value, tag_options, escape)
        end
      end

      def extras(&block)
        [prepend, (yield if block_given?), append, append_button, help_inline, error, success, warning, help_block].join('').html_safe
      end

      def objectify_options(options)
        super.except(:label, :help_inline, :error, :success, :warning, :help_block, :prepend, :append, :append_button, :control_group)
      end
    end
  end
end
