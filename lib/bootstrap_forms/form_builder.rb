module BootstrapForms
  class FormBuilder < ActionView::Helpers::FormBuilder
    delegate :content_tag, :hidden_field_tag, :check_box_tag, :radio_button_tag, :link_to, :to => :@template

    def error_messages
      if object.errors.full_messages.any?
        content_tag(:div, :class => 'alert-message block-message error') do
          link_to('&times;'.html_safe, '#', :class => 'close') +
          content_tag(:p, "<strong>Oh snap! You got an error!</strong> Fix the errors below and try again.".html_safe) +
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

    def bootstrap_fields_for(record_name, record_object = nil, options = {}, &block)
      options[:builder] = BootstrapForms::FormBuilder
      fields_for(record_name, record_object, options, &block)
    end

    %w(collection_select select check_box email_field file_field number_field password_field phone_field radio_button range_field search_field telephone_field text_area text_field url_field).each do |method_name|
      define_method(method_name) do |name, *args|
        @name = name
        @options = args.extract_options!
        @args = args

        clearfix_div do
          label_field + input_div do
            extras { super(name, *(@args << @options)) }
          end
        end
      end
    end

    def collection_check_boxes(attribute, records, record_id, record_name, *args)
      @name = attribute
      @options = args.extract_options!
      @args = args

      clearfix_div do
        label_field + input_div do
          extras do
            content_tag(:ul, :class => 'inputs-list') do
              records.collect do |record|
                element_id = "#{object_name}_#{attribute}_#{record.send(record_id)}"
                checkbox = check_box_tag("#{object_name}[#{attribute}][]", record.send(record_id), object.send(attribute).include?(record.send(record_id)), :id => element_id)

                content_tag(:li) do
                  content_tag(:label) do
                    checkbox + content_tag(:span, record.send(record_name))
                  end
                end
              end.join('').html_safe
            end
          end
        end + hidden_field_tag("#{object_name}[#{attribute}][]")
      end
    end

    def collection_radio_buttons(attribute, records, record_id, record_name, *args)
      @name = attribute
      @options = args.extract_options!
      @args = args

      clearfix_div do
        label_field + input_div do
          extras do
            content_tag(:ul, :class => 'inputs-list') do
              records.collect do |record|
                element_id = "#{object_name}_#{attribute}_#{record.send(record_id)}"
                radiobutton = radio_button_tag("#{object_name}[#{attribute}][]", record.send(record_id), object.send(attribute) == record.send(record_id), :id => element_id)

                content_tag(:li) do
                  content_tag(:label) do
                    radiobutton + content_tag(:span, record.send(record_name))
                  end
                end
              end.join('').html_safe
            end
          end
        end
      end
    end

    def uneditable_field(name, *args)
      @name = name
      @options = args.extract_options!
      @args = args

      clearfix_div do
        label_field + input_div do
          extras do
            content_tag(:span, :class => 'uneditable-input') do
              @options[:value] || object.send(@name.to_sym)
            end
          end
        end
      end
    end

    def submit(name = nil, *args)
      @name = name
      @options = args.extract_options!
      @args = args

      @options[:class] = 'btn primary'

      content_tag(:div, :class => 'actions') do
        super(name, *(args << @options)) + ' ' + link_to('Cancel', @options[:back_path] || :back, :class => 'btn')
      end
    end

    private
    def clearfix_div(&block)
      @options[:error] = object.errors[@name].collect{|e| "#{@options[:label] || @name} #{e}".humanize}.join(', ') unless object.errors[@name].empty?

      klasses = ['clearfix']
      klasses << 'error' if @options[:error]
      klasses << 'success' if @options[:success]
      klasses << 'warning' if @options[:warning]
      klass = klasses.join(' ')

      content_tag(:div, :class => klass, &block)
    end

    def input_div(&block)
      content_tag(:div, :class => 'input') do
        if @options[:append] || @options[:prepend]
          klass = 'input-prepend' if @options[:prepend]
          klass = 'input-append' if @options[:append]
          content_tag(:div, :class => klass, &block)
        else
          yield if block_given?
        end
      end
    end

    def label_field(&block)
      required = object.class.validators_on(@name).any? { |v| v.kind_of? ActiveModel::Validations::PresenceValidator }
      label(@name, block_given? ? block : @options[:label], :class => ('required' if required))
    end

    %w(help_inline error success warning help_block append prepend).each do |method_name|
      define_method(method_name) do |*args|
        return '' unless value = @options[method_name.to_sym]
        klass = 'help-inline'
        klass = 'help-block' if method_name == 'help_block'
        klass = 'add-on' if method_name == 'append' || method_name == 'prepend'
        content_tag(:span, value, :class => klass)
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