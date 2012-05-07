require 'spec_helper'

describe "BootstrapForms::FormBuilder" do
  context "given a setup builder" do
    before(:each) do
      @project = Project.new
      @template = ActionView::Base.new
      @template.output_buffer = ""
      @builder = BootstrapForms::FormBuilder.new(:item, @project, @template, {}, proc {})
    end

    describe "with no options" do
      describe "error_messages" do
        it "returns empty string without errors" do
          @builder.error_messages.should == ""
        end

        context "with errors" do
          before(:each) do
            @project.errors.add("name")
            @result = @builder.error_messages
          end

          it "is wrapped in error div" do
            @result.should match /^<div class="alert alert-block alert-error validation-errors">.*<\/div>$/
          end

          it "has a list with errors" do
            @result.should match /<ul><li>Name is invalid<\/li><\/ul>/
          end

          it "has error title" do
            @result.should match /<h4 class="alert-heading">#{I18n.t('bootstrap_forms.errors.header', :model => Project.model_name.human)}<\/h4>/
          end

          it "has error message on field" do
            @builder.text_field("name").should == "<div class=\"control-group error\"><label class=\"control-label\" for=\"item_name\">Name</label><div class=\"controls\"><input id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><span class=\"help-inline\">Name is invalid</span></div></div>"
          end

          it "joins passed error message and validation errors with ', '" do
            @builder.text_field("name", :error => 'This is an error!').should == "<div class=\"control-group error\"><label class=\"control-label\" for=\"item_name\">Name</label><div class=\"controls\"><input id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><span class=\"help-inline\">This is an error!, Name is invalid</span></div></div>"
          end
        end
      end

      describe "text_area" do
        before(:each) do
          @result = @builder.text_area "name"
        end

        it "has textarea input" do
          @result.should match /textarea/
        end
      end

      describe "check_box" do
        it "generates wrapped input" do
          @builder.check_box("name").should == "<div class=\"control-group\"><div class=\"controls\"><label class=\"checkbox\" for=\"item_name\"><input name=\"item[name]\" type=\"hidden\" value=\"0\" /><input id=\"item_name\" name=\"item[name]\" type=\"checkbox\" value=\"1\" />Name</label></div></div>"
        end

        it "allows custom label" do
          @builder.check_box("name", :label => "custom label").should match /custom label<\/label>/
        end

        it "allows no label with :label => false " do
          @builder.check_box("name", :label => false).should_not match /<\/label>/
        end
        it "allows no label with :label => '' " do
          @builder.check_box("name", :label => '').should_not match /<\/label>/
        end
      end

      describe "radio_buttons" do
        before do
          if RUBY_VERSION < '1.9'
            @options = ActiveSupport::OrderedHash.new
            @options['One'] = '1'
            @options['Two'] = '2'
          else
            @options = {'One' => '1', 'Two' => '2'}
          end
        end

        it "doesn't use field_options from previously generated field" do
          @builder.text_field :name, :label => 'Heading', :help_inline => 'Inline help', :help_block => 'Block help'
          @builder.radio_buttons(:name, @options).should == "<div class=\"control-group\"><label class=\"control-label\" for=\"item_name\">Name</label><div class=\"controls\"><label class=\"radio\" for=\"item_name_1\"><input id=\"item_name_1\" name=\"item[name]\" type=\"radio\" value=\"1\" />One</label><label class=\"radio\" for=\"item_name_2\"><input id=\"item_name_2\" name=\"item[name]\" type=\"radio\" value=\"2\" />Two</label></div></div>"
        end

        it "sets field_options" do
          @builder.radio_buttons(:name, {"One" => "1", "Two" => "2"})
          @builder.instance_variable_get("@field_options").should == {:error => nil}
        end

        it "generates wrapped input" do
          @builder.radio_buttons(:name, @options).should == "<div class=\"control-group\"><label class=\"control-label\" for=\"item_name\">Name</label><div class=\"controls\"><label class=\"radio\" for=\"item_name_1\"><input id=\"item_name_1\" name=\"item[name]\" type=\"radio\" value=\"1\" />One</label><label class=\"radio\" for=\"item_name_2\"><input id=\"item_name_2\" name=\"item[name]\" type=\"radio\" value=\"2\" />Two</label></div></div>"
        end

        it "allows custom label" do
          @builder.radio_buttons(:name, @options, {:label => "custom label"}).should match /custom label<\/label>/
        end
      end

      (%w{email file number password range search text url }.map{|field| ["#{field}_field",field]} + [["telephone_field", "tel"], ["phone_field", "tel"]]).each do |field, type|
        describe "#{field}" do
          context "result" do
            before(:each) do
              @result = @builder.send(field, "name")
            end

            it "is wrapped" do
              @result.should match /^<div class=\"control-group\"><label class=\"control-label\" for=\"item_name\">Name<\/label><div class=\"controls\">.*<\/div><\/div>$/
            end

            it "has an input of type: #{type}" do
              @result.should match /<input.*type=["#{type}"]/
            end
          end # result

          context "call expectations" do
            %w(control_group_div label_field input_div extras).map(&:to_sym).each do |method|
              it "calls #{method}" do
                @builder.should_receive(method).and_return("")
              end
            end

            after(:each) do
              @builder.send(field, "name")
            end
          end # call expectations

        end # field
      end # fields
    end # no options

    describe "extras" do
      context "text_field" do
        it "adds span for inline help" do
          @builder.text_field(:name, :help_inline => 'help me!').should == "<div class=\"control-group\"><label class=\"control-label\" for=\"item_name\">Name</label><div class=\"controls\"><input id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><span class=\"help-inline\">help me!</span></div></div>"
        end

        it "adds help block" do
          @builder.text_field(:name, :help_block => 'help me!').should == "<div class=\"control-group\"><label class=\"control-label\" for=\"item_name\">Name</label><div class=\"controls\"><input id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><p class=\"help-block\">help me!</p></div></div>"
        end

        it "adds error message and class" do
          @builder.text_field(:name, :error => 'This is an error!').should == "<div class=\"control-group error\"><label class=\"control-label\" for=\"item_name\">Name</label><div class=\"controls\"><input id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><span class=\"help-inline\">This is an error!</span></div></div>"
        end

        it "adds success message and class" do
          @builder.text_field(:name, :success => 'This checked out OK').should == "<div class=\"control-group success\"><label class=\"control-label\" for=\"item_name\">Name</label><div class=\"controls\"><input id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><span class=\"help-inline\">This checked out OK</span></div></div>"
        end

        it "adds warning message and class" do
          @builder.text_field(:name, :warning => 'Take a look at this...').should == "<div class=\"control-group warning\"><label class=\"control-label\" for=\"item_name\">Name</label><div class=\"controls\"><input id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><span class=\"help-inline\">Take a look at this...</span></div></div>"
        end

        it "prepends passed text" do
          @builder.text_field(:name, :prepend => '@').should == "<div class=\"control-group\"><label class=\"control-label\" for=\"item_name\">Name</label><div class=\"controls\"><div class=\"input-prepend\"><span class=\"add-on\">@</span><input id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /></div></div></div>"
        end

        it "appends passed text" do
          @builder.text_field(:name, :append => '@').should == "<div class=\"control-group\"><label class=\"control-label\" for=\"item_name\">Name</label><div class=\"controls\"><div class=\"input-append\"><input id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><span class=\"add-on\">@</span></div></div></div>"
        end

        it "prepends and appends passed text" do
          @builder.text_field(:name, :append => '@', :prepend => '#').should == "<div class=\"control-group\"><label class=\"control-label\" for=\"item_name\">Name</label><div class=\"controls\"><div class=\"input-prepend input-append\"><span class=\"add-on\">\#</span><input id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><span class=\"add-on\">@</span></div></div></div>"
        end
      end
       context "label option" do
        %w(select email_field file_field number_field password_field search_field text_area text_field url_field).each do |method_name|

          it "should not add a label when ''" do
            @builder.send(method_name.to_sym, 'name', :label => '').should_not match /<\/label>/
          end

          it "should not add a label when false" do
            @builder.send(method_name.to_sym, 'name', :label => false).should_not match /<\/label>/
          end
        end
      end
    end # extras

    describe "form actions" do
      context "actions" do
        it "adds additional block content" do
          @builder.actions do
            @builder.submit
          end.should == "<div class=\"form-actions\"><input class=\"btn btn-primary\" name=\"commit\" type=\"submit\" value=\"Create Project\" /></div>"
        end
      end

      context "submit" do
        it "adds btn primary class" do
          @builder.submit.should == "<input class=\"btn btn-primary\" name=\"commit\" type=\"submit\" value=\"Create Project\" />"
        end
      end

      context "button" do
        it "adds btn primary class" do
          @builder.submit.should == "<input class=\"btn btn-primary\" name=\"commit\" type=\"submit\" value=\"Create Project\" />"
        end
      end

      context "cancel" do
        it "creates link with correct class" do
          @builder.should_receive(:link_to).with(I18n.t('bootstrap_forms.buttons.cancel'), :back, :class => 'btn cancel').and_return("")
          @builder.cancel
        end
      end
    end # actions
  end # setup builder

end
