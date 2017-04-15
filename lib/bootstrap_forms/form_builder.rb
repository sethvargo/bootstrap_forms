module BootstrapForms
  class FormBuilder < ::ActionView::Helpers::FormBuilder
    require_relative 'helpers/wrappers'
    include BootstrapForms::Helpers::Wrappers

    delegate :content_tag, :hidden_field_tag, :check_box_tag, :radio_button_tag, :button_tag, :link_to, :to => :@template

    def error_messages
      if object.try(:errors) and object.errors.full_messages.any?
        content_tag(:div, :class => 'alert alert-block alert-error validation-errors') do
          content_tag(:h4, I18n.t('bootstrap_forms.errors.header', :model => object.class.model_name.human), :class => 'alert-heading') +
          content_tag(:ul) do
            object.errors.full_messages.map do |message|
              content_tag(:li, message)
            end.join('').html_safe
          end
        end
      else
        '' # return empty string
      end
    end

    %w(
      select
      collection_select
      country_select
      datetime_select
      date_select
      time_select
      time_zone_select

      email_field
      file_field
      number_field
      password_field
      phone_field
      range_field
      search_field
      telephone_field
      text_area
      text_field
      url_field
    ).each do |method_name|
      define_method(method_name) do |name, *raw_args|

        # Special case for select
        if method_name == 'select' or method_name == 'country_select'
          while raw_args.length < 3
            raw_args << {}
          end
        end

        options = {}
        html_options = {}

        if raw_args.length > 0
          if raw_args[-1].is_a?(Hash) && raw_args[-2].is_a?(Hash)
            html_options = raw_args[-1]
            options = raw_args[-2]
          elsif raw_args[-1].is_a?(Hash)
            options = raw_args[-1]
          end
        end

        # Add options hash to argument array if its empty
        raw_args << options if raw_args.length == 0

        @name = name
        @field_options = field_options(options)
        @args = options

        if %w(email_field
              file_field
              number_field
              password_field
              phone_field
              range_field
              search_field
              telephone_field
              text_area
              text_field
              url_field).include?(method_name)

          @field_options[:class] ||= 'form-control'

        end

        control_group_div do
          label_field + input_div do
            options.merge!(@field_options.merge(required_attribute))
            input_append = (options[:append] || options[:prepend] || options[:append_button]) ? true : nil
            extras(input_append) { super(name, *raw_args) }
          end
        end
      end
    end

    def check_box(name, args = {}, checked_value = "1", unchecked_value = "0")
      @name = name
      @field_options = field_options(args)
      @args = args

      control_group_div do
        input_div do
          @field_options.merge!(required_attribute)
          if @field_options[:label] == false || @field_options[:label] == ''
            extras { super(name, @args.merge(@field_options)) }
          else
            klasses = 'checkbox'
            klasses << ' inline' if @field_options.delete(:inline) == true
            @args.delete :inline
            label(@name, :class => klasses) do
              extras { super(name, @args.merge(@field_options), checked_value, unchecked_value) + (@field_options[:label].blank? ? human_attribute_name : @field_options[:label])}
            end
          end
        end
      end
    end

    def radio_buttons(name, values = {}, opts = {})
      @name = name
      @field_options = @options.slice(:namespace, :index).merge(opts.merge(required_attribute))
      control_group_div do
        label_field + input_div do
          klasses = 'radio'
          klasses << ' inline' if @field_options.delete(:inline) == true

          buttons = values.map do |text, value|
            radio_options = @field_options
            if value.is_a? Hash
              radio_options = radio_options.merge(value)
              value = radio_options.delete(:value)
            end

            label("#{@name}_#{value}", :class => klasses) do
              radio_button(name, value, radio_options) + text
            end
          end.join('')
          buttons << extras
          buttons.html_safe
        end
      end
    end

    def collection_check_boxes(attribute, records, record_id, record_name, args = {})
      @name = attribute
      @field_options = field_options(args)
      @args = args

      control_group_div do
        label_field + input_div do
          options = @field_options.except(*BOOTSTRAP_OPTIONS).merge(required_attribute)
          # Since we're using check_box_tag() we may have to lookup the instance ourselves
          instance = object || @template.instance_variable_get("@#{object_name}")
          boxes = records.collect do |record|
            options[:id] = "#{object_name}_#{attribute}_#{record.send(record_id)}"
            checkbox = check_box_tag("#{object_name}[#{attribute}][]", record.send(record_id), [instance.send(attribute)].flatten.include?(record.send(record_id)), options)

            content_tag(:label, :class => ['checkbox', ('inline' if @field_options[:inline])].compact) do
              checkbox + record.send(record_name)
            end
          end.join('')
          boxes << extras
          boxes.html_safe
        end
      end
    end

    def collection_radio_buttons(attribute, records, record_id, record_name, args = {})
      @name = attribute
      @field_options = field_options(args)
      @args = args

      control_group_div do
        label_field + input_div do
          options = @field_options.merge(required_attribute)
          buttons = records.collect do |record|
            radiobutton = radio_button(attribute, record.send(record_id), options)
            content_tag(:label, :class => ['radio', ('inline' if @field_options[:inline])].compact) do
              radiobutton + record.send(record_name)
            end
          end.join('')
          buttons << extras
          buttons.html_safe
        end
      end
    end

    def uneditable_input(name, args = {})
      @name = name
      @field_options = field_options(args)
      @args = args

      control_group_div do
        label_field + input_div do
          extras do
            value = @field_options.delete(:value)
            @field_options[:class] = [@field_options[:class], 'uneditable-input'].compact

            content_tag(:span, @field_options) do
              value || object.send(@name.to_sym) rescue nil
            end
          end
        end
      end
    end

    def button(name = nil, args = {})
      name, args = nil, name if name.is_a?(Hash)
      @name = name
      @field_options = field_options(args)
      @args = args

      @field_options[:class] ||= 'btn'
      super(name, args.merge(@field_options))
    end

    def submit(name = nil, args = {})
      name, args = nil, name if name.is_a?(Hash)
      @name = name
      @field_options = field_options(args)
      @args = args

      @field_options[:class] ||= 'btn btn-primary'
      super(name, args.merge(@field_options))
    end

    def cancel(name = nil, args = {})
      name, args = nil, name if name.is_a?(Hash)
      name ||= I18n.t('bootstrap_forms.buttons.cancel')
      @field_options = field_options(args)
      @field_options[:class] ||= 'btn cancel'
      @field_options[:back] ||= :back
      link_to(name, @field_options[:back], :class => @field_options[:class])
    end

    def actions(&block)
      content_tag(:div, :class => 'form-actions') do
        if block_given?
          yield
        else
          [submit, cancel].join(' ').html_safe
        end
      end
    end

    private
    def field_options(args)
      if @options
        @options.slice(:namespace, :index).merge(args)
      else
        args
      end
    end
  end
end
