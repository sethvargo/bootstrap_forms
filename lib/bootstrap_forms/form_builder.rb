module BootstrapForms
  class FormBuilder < ::ActionView::Helpers::FormBuilder
    include BootstrapForms::Helpers::Wrappers

    delegate :content_tag, :hidden_field_tag, :check_box_tag, :radio_button_tag, :button_tag, :link_to, :to => :@template

    def error_messages
      if object.errors.full_messages.any?
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

    %w(collection_select select country_select time_zone_select email_field file_field number_field password_field phone_field range_field search_field telephone_field text_area text_field url_field).each do |method_name|
      define_method(method_name) do |name, *args|
        @name = name
        @field_options = args.extract_options!
        @args = args

        control_group_div do
          label_field + input_div do
            extras { super(name, *(@args << @field_options)) }
          end
        end
      end
    end

    def check_box(name, *args)
      @name = name
      @field_options = args.extract_options!
      @args = args

      control_group_div do
        input_div do
          if @field_options[:label] == false || @field_options[:label] == ''
            extras { super(name, *(@args << @field_options)) }
          else
            label(@name, :class => [ 'checkbox', required_class ].compact.join(' ')) do
              extras { super(name, *(@args << @field_options)) + (@field_options[:label].blank? ? human_attribute_name : @field_options[:label])}
            end
          end
        end
      end
    end

    def radio_buttons(name, values = {}, opts = {})
      @name = name
      @options = opts
      @field_options = opts
      control_group_div do
        label_field + input_div do
          values.map do |text, value|
            if @field_options[:label] == '' || @field_options[:label] == false
              extras { radio_button(name, value, @options) + text }
            else
              label("#{@name}_#{value}", :class => [ 'radio', required_class ].compact.join(' ')) do
                extras { radio_button(name, value, @options) + text }
              end
            end
          end.join.html_safe
        end
      end
    end

    def collection_check_boxes(attribute, records, record_id, record_name, *args)
      @name = attribute
      @field_options = args.extract_options!
      @args = args

      control_group_div do
        label_field + extras do
          content_tag(:div, :class => 'controls') do
            records.collect do |record|
              element_id = "#{object_name}_#{attribute}_#{record.send(record_id)}"
              checkbox = check_box_tag("#{object_name}[#{attribute}][]", record.send(record_id), [object.send(attribute)].flatten.include?(record.send(record_id)), @field_options.merge({:id => element_id}))

              content_tag(:label, :class => ['checkbox', ('inline' if @field_options[:inline])].compact.join(' ')) do
                checkbox + content_tag(:span, record.send(record_name))
              end
            end.join('').html_safe
          end
        end
      end
    end

    def collection_radio_buttons(attribute, records, record_id, record_name, *args)
      @name = attribute
      @field_options = args.extract_options!
      @args = args

      control_group_div do
        label_field + extras do
          content_tag(:div, :class => 'controls') do
            records.collect do |record|
              element_id = "#{object_name}_#{attribute}_#{record.send(record_id)}"
              radiobutton = radio_button_tag("#{object_name}[#{attribute}]", record.send(record_id), object.send(attribute) == record.send(record_id), @field_options.merge({:id => element_id}))

              content_tag(:label, :class => ['radio', ('inline' if @field_options[:inline])].compact.join(' ')) do
                radiobutton + content_tag(:span, record.send(record_name))
              end
            end.join('').html_safe
          end
        end
      end
    end

    def uneditable_input(name, *args)
      @name = name
      @field_options = args.extract_options!
      @args = args

      control_group_div do
        label_field + input_div do
          extras do
            content_tag(:span, :class => 'uneditable-input') do
              @field_options[:value] || object.send(@name.to_sym)
            end
          end
        end
      end
    end

    def button(name = nil, *args)
      @name = name
      @field_options = args.extract_options!
      @args = args

      @field_options[:class] = 'btn btn-primary'
      super(name, *(args << @field_options))
    end

    def submit(name = nil, *args)
      @name = name
      @field_options = args.extract_options!
      @args = args

      @field_options[:class] = 'btn btn-primary'
      super(name, *(args << @field_options))
    end

    def cancel(*args)
      @field_options = args.extract_options!
      link_to(I18n.t('bootstrap_forms.buttons.cancel'), (@field_options[:back] || :back), :class => 'btn cancel')
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
  end
end
