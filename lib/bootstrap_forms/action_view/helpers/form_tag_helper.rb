module BootstrapForms
  module ActionView
    module Helpers
      module FormTagHelper
        include ::Helpers::Wrappers
        
        def bootstrap_form_tag(url_for_options = {}, options = {}, &block)
          html_options = html_options_for_form(url_for_options, options)
          if block_given?
            form_tag_in_block(html_options, &block)
          else
            form_tag_html(html_options)
          end
        end
      
        %w(button_tag check_box_tag email_field_tag field_set_tag file_field_tag form_tag hidden_field_tag image_submit_tag label_tag number_field_tag password_field_tag phone_field_tag radio_button_tag range_field_tag search_field_tag select_tag submit_tag telephone_field_tag text_area_tag text_field_tag url_field_tag utf8_enforcer_tag).each do |method_name|
          # prefix each method with bootstrap_*
          define_method("bootstrap_#{method_name}") do |name, *args|
            @name = name
            @field_options = args.extract_options!
            @args = args

            control_group_div do
              label_field + input_div do
                extras { method_name(name, *(@args << @field_options)) }
              end
            end
          end
        end
      end
    end
  end
end