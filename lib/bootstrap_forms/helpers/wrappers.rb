module BootstrapForms
  module Helpers
    module Wrappers
      BOOTSTRAP_OPTIONS = [ :label, :help_inline, :error, :success, :warning, :help_block, :prepend, :append, :append_button, :control_group ]

      private
      def control_group_div(&block)
        field_errors = error_string
        if @field_options[:error]
          (@field_options[:error] << ", " << field_errors) if field_errors
        else
          @field_options[:error] = field_errors
        end

        klasses = []
        klasses << 'form-group' unless @field_options[:control_group] == false
        klasses << 'error' if @field_options[:error]
        klasses << 'success' if @field_options[:success]
        klasses << 'warning' if @field_options[:warning]
        klasses << 'required' if @field_options.merge(required_attribute)[:required]

        control_group_options = {}
        control_group_options[:class] = klasses if !klasses.empty?

        if @field_options[:control_group] == false
          yield
        else
          content_tag(:div, control_group_options, &block)
        end
      end

      def error_string
        if respond_to?(:object) and object.respond_to?(:errors)
          errors = object.errors[@name]
          if errors.present?
            errors.map { |e|
              object.errors.full_message(@name, e)
            }.join(", ")
          end
        end
      end

      def human_attribute_name
        object_name = @object_name.to_s.dup
        
        # Copied from https://github.com/rails/rails/blob/fb24f419051aec00790a8e6fb5785eeb6f503f4a/actionpack/lib/action_view/helpers/tags/label.rb#L38
        object_name.gsub!(/\[(.*)_attributes\]\[\d\]/, '.\1')
        method = @name.to_s
        if object.respond_to?(:to_model)
          key = object.class.model_name.i18n_key
          i18n_default = ["#{key}.#{method}".to_sym, ""]
        end

        i18n_default ||= ""
        result = I18n.t("#{object_name}.#{method}", :default => i18n_default, :scope => "helpers.label").presence
        
        result ||= if object && object.class.respond_to?(:human_attribute_name)
          object.class.human_attribute_name(method)
        end
        
        result ||= method.humanize
        
        result
      end

      def input_div(&block)
        content_options = {}
        content_options[:class] = 'controls'
        if @field_options[:control_group] == false
          @field_options.delete :control_group
          write_input_div(&block)
        else
          content_tag(:div, :class => 'form-controls') do
            write_input_div(&block)
          end
        end
      end

      def write_input_div(&block)
        if @field_options[:append] || @field_options[:prepend] || @field_options[:append_button]
          klass = []
          klass << 'input-prepend' if @field_options[:prepend]
          klass << 'input-append' if @field_options[:append] || @field_options[:append_button]
          html = content_tag(:div, :class => klass, &block)
          html << extras(false, &block) if @field_options[:help_inline] || @field_options[:help_block] || @field_options[:error] || @field_options[:success] || @field_options[:warning]
          html
        else
          yield if block_given?
        end
      end

      def label_field(&block)
        if @field_options[:label] == '' || @field_options[:label] == false
          return ''.html_safe
        else
          label_options = {}
          label_options[:class] = 'form-label' unless @field_options[:control_group] == false
          if respond_to?(:object)
             label(@name, block_given? ? block : @field_options[:label], label_options)
           else
             label_tag(@name, block_given? ? block : @field_options[:label], label_options)
           end
        end
      end

      def required_attribute
        return {} if @field_options.present? && @field_options.has_key?(:required) && !@field_options[:required]

        if respond_to?(:object) and object.respond_to?(:errors) and object.class.respond_to?('validators_on')
          return { :required => true } if object.class.validators_on(@name).any? { |v| v.kind_of?( ActiveModel::Validations::PresenceValidator ) && valid_validator?( v ) }
        end
        {}
      end

      def valid_validator?(validator)
        !conditional_validators?(validator) && action_validator_match?(validator)
      end

      def conditional_validators?(validator)
        validator.options.include?(:if) || validator.options.include?(:unless)
      end

      def action_validator_match?(validator)
        return true if !validator.options.include?(:on)
        case validator.options[:on]
        when :save
          true
        when :create
          !object.persisted?
        when :update
          object.persisted?
        end
      end


      %w(help_inline error success warning help_block append append_button prepend).each do |method_name|
        define_method(method_name) do |*args|
          return '' unless value = @field_options[method_name.to_sym]

          case method_name
          when 'help_block'
            content_tag(:span, value, :class => 'help-block')
          when 'append', 'prepend'
            content_tag(:span, value, :class => 'add-on')
          when 'append_button'
            if value.is_a? Array
              buttons_options = value
            else
              buttons_options = [value]
            end

            buttons_options.map  do |button_options|
              button_options = button_options.dup
              value = ''
              if button_options.has_key? :icon
                value << content_tag(:i, '', { :class => button_options.delete(:icon) })
                value << ' '
              end

              value << ERB::Util.h(button_options.delete(:label))
              options = {:type => 'button', :class => 'btn'}.merge(button_options)
              content_tag(:button, value, options, false)
            end.join
          when 'error', 'success', 'warning'
            content_tag(:span, value, :class => "help-inline #{method_name}-message")
          else
            content_tag(:span, value, :class => 'help-inline')
          end
        end
      end

      def extras(input_append = nil, &block)
        case input_append
        when nil
          [prepend, (yield if block_given?), append, append_button, help_inline, error, success, warning, help_block].join('').html_safe
        when true
          [prepend, (yield if block_given?), append, append_button].join('').html_safe
        when false
          [help_inline, error, success, warning, help_block].join('').html_safe
        end
      end

      def objectify_options(options)
        super.except(*BOOTSTRAP_OPTIONS)
      end
    end
  end
end
