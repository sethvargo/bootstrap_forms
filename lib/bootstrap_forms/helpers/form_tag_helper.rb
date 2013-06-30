module BootstrapForms
  module Helpers
    module FormTagHelper
      include BootstrapForms::Helpers::Wrappers

      def bootstrap_form_tag(url_for_options = {}, options = {}, &block)
        form_tag(url_for_options, options, &block)
      end

      %w(
        check_box_tag
        email_field_tag
        file_field_tag
        image_submit_tag
        number_field_tag
        password_field_tag
        phone_field_tag
        radio_button_tag
        range_field_tag
        search_field_tag
        select_tag
        telephone_field_tag
        text_area_tag
        text_field_tag
        url_field_tag
      ).each do |method_name|
        # prefix each method with bootstrap_*
        define_method("bootstrap_#{method_name}") do |name, *args|
          @name = name
          @field_options = field_options(args)
          @args = args

          control_group_div do
            label_field + input_div do
              extras { send(method_name.to_sym, name, *(@args << @field_options)) }
            end
          end
        end
      end

      def uneditable_input_tag(name, *args)
        @name = name
        @field_options = field_options(args)
        @args = args

        control_group_div do
          label_field + input_div do
            extras do
              content_tag(:span, :class => 'uneditable-input') do
                @field_options[:value]
              end
            end
          end
        end
      end

      def bootstrap_button_tag(name = nil, *args)
        @name = name
        @field_options = field_options(args)
        @args = args

        @field_options[:class] ||= 'btn btn-primary'
        button_tag(name, *(args << @field_options))
      end

      def bootstrap_submit_tag(name = nil, *args)
        @name = name
        @field_options = field_options(args)
        @args = args

        @field_options[:class] ||= 'btn btn-primary'
        submit_tag(name, *(args << @field_options))
      end

      def bootstrap_cancel_tag(*args)
        @field_options = field_options(args)
        @field_options[:class] ||= 'btn cancel'
        link_to(I18n.t('bootstrap_forms.buttons.cancel'), (@field_options[:back] || :back), @field_options)
      end

      def bootstrap_actions(&block)
        content_tag(:div, :class => 'form-actions') do
          if block_given?
            yield
          else
            [ bootstrap_submit_tag, bootstrap_cancel_tag ].join(' ').html_safe
          end
        end
      end

      private
      def field_options(args)
        if @options
          @options.slice(:namespace, :index).merge(args.extract_options!)
        else
          args.extract_options!
        end
      end
    end
  end
end
