
require 'country_select'

shared_examples 'a bootstrap form' do
  describe 'with no options' do
    describe 'error_messages' do
      it 'returns empty string without errors' do
        @builder.error_messages.should == ''
      end
    end

    describe 'text_area' do
      before(:each) do
        @result = @builder.text_area 'name'
      end

      it 'has textarea input' do
        @result.should match /textarea/
      end
    end

    describe 'uneditable_input' do
      it 'generates wrapped input' do
        @builder.uneditable_input('name').should == "<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><span class=\"uneditable-input\"></span></div></div>"
      end

      it 'allows for an id' do
        @builder.uneditable_input('name', :id => 'myid').should match /<span.*id="myid"/
      end
    end

    describe 'check_box' do
      it 'generates wrapped input' do
        @builder.check_box('name').should == "<div class=\"form-group\"><div class=\"form-controls\"><label class=\"checkbox\" for=\"item_name\"><input name=\"item[name]\" type=\"hidden\" value=\"0\" /><input id=\"item_name\" name=\"item[name]\" type=\"checkbox\" value=\"1\" />Name</label></div></div>"
      end

      it 'allows custom label' do
        @builder.check_box('name', :label => 'custom label').should match /custom label<\/label>/
      end

      it 'allows no label with :label => false ' do
        @builder.check_box('name', :label => false).should_not match /<\/label>/
      end
      it 'allows no label with :label => '' ' do
        @builder.check_box('name', :label => '').should_not match /<\/label>/
      end

      it 'adds inline class' do
        @builder.check_box('name', :inline => true).should  == "<div class=\"form-group\"><div class=\"form-controls\"><label class=\"checkbox inline\" for=\"item_name\"><input name=\"item[name]\" type=\"hidden\" value=\"0\" /><input id=\"item_name\" name=\"item[name]\" type=\"checkbox\" value=\"1\" />Name</label></div></div>"
      end

      it 'uses passed values' do
        @builder.check_box('name', {}, "checked value", "unchecked value").should  == "<div class=\"control-group\"><div class=\"controls\"><label class=\"checkbox\" for=\"item_name\"><input name=\"item[name]\" type=\"hidden\" value=\"unchecked value\" /><input id=\"item_name\" name=\"item[name]\" type=\"checkbox\" value=\"checked value\" />Name</label></div></div>"
      end

      it 'allows symbol as field name' do
        @builder.check_box(:name).should == @builder.check_box('name')
      end

      context "with helper translations" do
        before(:all) { I18n.backend.store_translations I18n.locale, {:helpers => {:label => {"item" => {"name" => "name translation"}}}} }
        after(:all)  { I18n.backend.reload! }
        it 'uses helper translation' do
          @builder.check_box(:name).should include("name translation")
        end
      end
    end

    describe 'radio_buttons' do
      before do
        @options = {'One' => '1', 'Two' => '2'}
      end

      it 'doesn\'t use field_options from previously generated field' do
        @builder.text_field :name, :label => 'Heading', :help_inline => 'Inline help', :help_block => 'Block help'
        @builder.radio_buttons(:name, @options).should == "<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><label class=\"radio\" for=\"item_name_1\"><input id=\"item_name_1\" name=\"item[name]\" type=\"radio\" value=\"1\" />One</label><label class=\"radio\" for=\"item_name_2\"><input id=\"item_name_2\" name=\"item[name]\" type=\"radio\" value=\"2\" />Two</label></div></div>"
      end

      it 'sets field_options' do
        @builder.radio_buttons(:name, {'One' => '1', 'Two' => '2'})
        @builder.instance_variable_get('@field_options').should == {:error => nil}
      end

      it 'generates wrapped input' do
        @builder.radio_buttons(:name, @options).should == "<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><label class=\"radio\" for=\"item_name_1\"><input id=\"item_name_1\" name=\"item[name]\" type=\"radio\" value=\"1\" />One</label><label class=\"radio\" for=\"item_name_2\"><input id=\"item_name_2\" name=\"item[name]\" type=\"radio\" value=\"2\" />Two</label></div></div>"
      end

      it 'allows custom label' do
        @builder.radio_buttons(:name, @options, {:label => 'custom label'}).should match /custom label<\/label>/
      end

      it 'allows no label' do
        @builder.radio_buttons(:name, @options, {:label => false}).should == "<div class=\"form-group\"><div class=\"form-controls\"><label class=\"radio\" for=\"item_name_1\"><input id=\"item_name_1\" name=\"item[name]\" type=\"radio\" value=\"1\" />One</label><label class=\"radio\" for=\"item_name_2\"><input id=\"item_name_2\" name=\"item[name]\" type=\"radio\" value=\"2\" />Two</label></div></div>"
      end

      it 'adds inline class' do
        @builder.radio_buttons(:name, @options, {:inline => true}).should == "<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><label class=\"radio inline\" for=\"item_name_1\"><input id=\"item_name_1\" name=\"item[name]\" type=\"radio\" value=\"1\" />One</label><label class=\"radio inline\" for=\"item_name_2\"><input id=\"item_name_2\" name=\"item[name]\" type=\"radio\" value=\"2\" />Two</label></div></div>"
      end

      it 'adds block help' do
        @builder.radio_buttons(:name, @options, :help_block => "Help me!").should == "<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><label class=\"radio\" for=\"item_name_1\"><input id=\"item_name_1\" name=\"item[name]\" type=\"radio\" value=\"1\" />One</label><label class=\"radio\" for=\"item_name_2\"><input id=\"item_name_2\" name=\"item[name]\" type=\"radio\" value=\"2\" />Two</label><span class=\"help-block\">Help me!</span></div></div>"
      end

      describe "with disabled option" do
        before do
          @options = {'One' => '1', 'Two' => {:value => '2', :disabled => true}}
        end

        it 'adds the disabled attribute' do
          @builder.radio_buttons(:name, @options).should include("<input disabled=\"disabled\" id=\"item_name_2\" name=\"item[name]\" type=\"radio\" value=\"2\" />Two<")
        end
      end
    end

    (%w{email file number password range search text url }.map{|field| ["#{field}_field",field]} + [['telephone_field', 'tel'], ['phone_field', 'tel']]).each do |field, type|
      describe "#{field}" do
        context 'result' do
          before(:each) do
            @result = @builder.send(field, 'name')
          end

          it 'is wrapped' do
            @result.should match /^<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name<\/label><div class=\"form-controls\">.*<\/div><\/div>$/
          end

          it "has an input of type: #{type}" do
            @result.should match /<input.*type="#{type}"/
          end
        end # result

        context 'call expectations' do
          %w(control_group_div label_field input_div extras).map(&:to_sym).each do |method|
            it "calls #{method}" do
              @builder.should_receive(method).and_return("")
            end
          end

          after(:each) do
            @builder.send(field, 'name')
          end
        end # call expectations

      end # field
    end # fields

    describe 'collection_radio_buttons' do
      before do
        @options = [ [["foo", "Foo"], ["bar", "Bar"]], :first, :last ]
      end

      it 'generates wrapped input' do
        @builder.collection_radio_buttons(:name, *@options).should eq "<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><label class=\"radio\"><input id=\"item_name_foo\" name=\"item[name]\" type=\"radio\" value=\"foo\" />Foo</label><label class=\"radio\"><input id=\"item_name_bar\" name=\"item[name]\" type=\"radio\" value=\"bar\" />Bar</label></div></div>"
      end

      it 'adds block help' do
        @builder.collection_radio_buttons(:name, *@options, :help_block => "Help me!").should == "<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><label class=\"radio\"><input id=\"item_name_foo\" name=\"item[name]\" type=\"radio\" value=\"foo\" />Foo</label><label class=\"radio\"><input id=\"item_name_bar\" name=\"item[name]\" type=\"radio\" value=\"bar\" />Bar</label><span class=\"help-block\">Help me!</span></div></div>"
      end
    end

    describe 'collection_check_boxes' do
      before do
        @options = [ [["foo", "Foo"], ["bar", "Bar"]], :first, :last ]
      end

      it 'generates wrapped input' do
        @builder.collection_check_boxes(:name, *@options).should eq "<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><label class=\"checkbox\"><input id=\"item_name_foo\" name=\"item[name][]\" type=\"checkbox\" value=\"foo\" />Foo</label><label class=\"checkbox\"><input id=\"item_name_bar\" name=\"item[name][]\" type=\"checkbox\" value=\"bar\" />Bar</label></div></div>"
      end

      it 'adds block help' do
        @builder.collection_check_boxes(:name, *@options, :help_block => "Help me!").should == "<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><label class=\"checkbox\"><input id=\"item_name_foo\" name=\"item[name][]\" type=\"checkbox\" value=\"foo\" />Foo</label><label class=\"checkbox\"><input id=\"item_name_bar\" name=\"item[name][]\" type=\"checkbox\" value=\"bar\" />Bar</label><span class=\"help-block\">Help me!</span></div></div>"
      end
    end

    describe 'collection select' do
      before(:each) do
        @result = @builder.collection_select(:name, [["foo", "Foo"]], :first, :last)
      end

      it 'is wrapped' do
        @result.should match /^<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name<\/label><div class=\"form-controls\">.*<\/div><\/div>$/
      end
    end

    describe 'collection select with html options' do
      before(:each) do
        @result = @builder.collection_select(:name, [["foo", "Foo"]], :first, :last, {}, :class => "baz")
      end

      it 'uses html options' do
        @result.should match /class=".*baz/
      end
    end

    describe "select" do

      describe "with hash values, options and html options" do
        it 'is wrapped' do
          @result = @builder.select(:name, {"False" => false}, { :selected => false }, {:class => "my-special-select"})
          @result.should match /^<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name<\/label><div class=\"form-controls\"><select class=\"my-special-select\" id=\"item_name\" name=\"item\[name\]\"><option value=\"false\" selected=\"selected\">False<\/option><\/select><\/div><\/div>$/
        end
      end

      describe "with only hash values and options" do
        it 'is wrapped' do
          @result = @builder.select(:name, {"False" => false}, { :selected => false })
          @result.should match /^<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name<\/label><div class=\"form-controls\"><select id=\"item_name\" name=\"item\[name\]\"><option value=\"false\" selected=\"selected\">False<\/option><\/select><\/div><\/div>$/
        end
      end

      describe "with only hash values" do
        it 'is wrapped' do
          @result = @builder.select(:name, {"False" => false})
          @result.should match /^<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name<\/label><div class=\"form-controls\"><select id=\"item_name\" name=\"item\[name\]\"><option value=\"false\">False<\/option><\/select><\/div><\/div>$/
        end
      end

    end

    describe 'country_select' do
      before(:each) do
        @result = @builder.country_select(:name,[ "United Kingdom", "France", "Germany" ])
      end

      it 'is wrapped' do
        @result.should match /^<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name<\/label><div class=\"form-controls\"><select id=\"item_name\" name=\"item\[name\]\"><option value=\"United Kingdom\">United Kingdom<\/option>/
      end
    end

    describe 'country_select with html options' do
      before(:each) do
        @result = @builder.country_select(:name, [ "United Kingdom", "France", "Germany" ], {}, :class => "baz")
      end

      it 'uses html options' do
        @result.should match /class=".*baz/
      end
    end

    describe 'country_select without option' do
      before(:each) do
        @result = @builder.country_select(:name)
      end

      it 'does not output error option' do
        @result.should_not match /error/
      end
    end

  end # no options

  describe 'extras' do
    context 'text_field' do
      it 'adds span for inline help' do
        @builder.text_field(:name, :help_inline => 'help me!').should == "<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><input class=\"form-control\" id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><span class=\"help-inline\">help me!</span></div></div>"
      end

      it 'adds help block' do
        @builder.text_field(:name, :help_block => 'help me!').should == "<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><input class=\"form-control\" id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><span class=\"help-block\">help me!</span></div></div>"
      end

      it 'marks it as required' do
        @builder.text_field(:name, :required => true).should == "<div class=\"form-group required\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><input class=\"form-control\" id=\"item_name\" name=\"item[name]\" required=\"required\" size=\"30\" type=\"text\" /></div></div>"
      end

      it 'adds error message and class' do
        @builder.text_field(:name, :error => 'This is an error!').should == "<div class=\"form-group error\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><input class=\"form-control\" id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><span class=\"help-inline error-message\">This is an error!</span></div></div>"
      end

      it 'adds error message, class and appended text' do
        @builder.text_field(:name, :error => 'This is an error!', :append => 'test').should == "<div class=\"form-group error\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><div class=\"input-append\"><input class=\"form-control\" id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><span class=\"add-on\">test</span></div><span class=\"help-inline error-message\">This is an error!</span></div></div>"
      end

      it 'adds success message and class' do
        @builder.text_field(:name, :success => 'This checked out OK').should == "<div class=\"form-group success\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><input class=\"form-control\" id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><span class=\"help-inline success-message\">This checked out OK</span></div></div>"
      end

      it 'adds warning message and class' do
        @builder.text_field(:name, :warning => 'Take a look at this...').should == "<div class=\"form-group warning\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><input class=\"form-control\" id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><span class=\"help-inline warning-message\">Take a look at this...</span></div></div>"
      end

      it 'prepends passed text' do
        @builder.text_field(:name, :prepend => '@').should == "<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><div class=\"input-prepend\"><span class=\"add-on\">@</span><input class=\"form-control\" id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /></div></div></div>"
      end

      it 'appends passed text' do
        @builder.text_field(:name, :append => '@').should == "<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><div class=\"input-append\"><input class=\"form-control\" id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><span class=\"add-on\">@</span></div></div></div>"
      end

      it 'prepends and appends passed text' do
        @builder.text_field(:name, :append => '@', :prepend => '#').should == "<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><div class=\"input-prepend input-append\"><span class=\"add-on\">\#</span><input class=\"form-control\" id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><span class=\"add-on\">@</span></div></div></div>"
      end

      it 'prepends, appends and adds inline help' do
        @builder.text_field(:name, :append => '@', :prepend => '#', :help_inline => 'some help').should == "<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><div class=\"input-prepend input-append\"><span class=\"add-on\">\#</span><input class=\"form-control\" id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><span class=\"add-on\">@</span></div><span class=\"help-inline\">some help</span></div></div>"
      end

      it 'prepends, appends and adds block help' do
        @builder.text_field(:name, :append => '@', :prepend => '#', :help_block => 'some help').should == "<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><div class=\"input-prepend input-append\"><span class=\"add-on\">\#</span><input class=\"form-control\" id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><span class=\"add-on\">@</span></div><span class=\"help-block\">some help</span></div></div>"
      end

      it 'appends button with default values' do
        @builder.text_field(:name, :append_button => { :label => 'button label' }).should == "<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><div class=\"input-append\"><input class=\"form-control\" id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><button class=\"btn\" type=\"button\">button label</button></div></div></div>"
      end

      it 'appends button and overrides class and type' do
        @builder.text_field(:name, :append_button => { :label => 'Danger!', :class => 'btn btn-danger', :type => 'submit' }).should == "<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><div class=\"input-append\"><input class=\"form-control\" id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><button class=\"btn btn-danger\" type=\"submit\">Danger!</button></div></div></div>"
      end

      it 'appends button with custom attributes' do
        @builder.text_field(:name, :append_button => { :label => 'button label', :data => { :custom_1 => 'value 1', :custom_2 => 'value 2' } }).should == "<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><div class=\"input-append\"><input class=\"form-control\" id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><button class=\"btn\" data-custom-1=\"value 1\" data-custom-2=\"value 2\" type=\"button\">button label</button></div></div></div>"
      end

      it 'appends button with an icon' do
        @builder.text_field(:name, :append_button => { :label => 'button label', :icon => 'icon-plus icon-white' }).should == "<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><div class=\"input-append\"><input class=\"form-control\" id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><button class=\"btn\" type=\"button\"><i class=\"icon-plus icon-white\"></i> button label</button></div></div></div>"
      end

      it 'appends button twice with same options' do
        options = { :label => 'button label', :icon => 'icon-plus icon-white' }
        first = @builder.text_field(:name, :append_button => options)
        second = @builder.text_field(:name, :append_button => options)
        second.should == first
      end

      it 'appends multiple buttons' do
        @builder.text_field(:name, :append_button => [{ :label => 'button 1' }, { :label => 'button 2' }]).should == "<div class=\"control-group\"><label class=\"control-label\" for=\"item_name\">Name</label><div class=\"controls\"><div class=\"input-append\"><input id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><button class=\"btn\" type=\"button\">button 1</button><button class=\"btn\" type=\"button\">button 2</button></div></div></div>"
      end

      it "does not add control group" do
        @builder.text_field(:name, :control_group => false).should == "<label for=\"item_name\">Name</label><input class=\"form-control\" id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" />"
      end

      it "adds control group attribute to html if :control_group is true" do
        @builder.text_field(:name, :control_group => true).should == "<div class=\"form-group\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><input class=\"form-control\" id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /></div></div>"
      end
    end

    context 'label option' do
      %w(email_field file_field number_field password_field search_field text_area text_field url_field).each do |method_name|

        it "should not add a label when ''" do
          @builder.send(method_name.to_sym, 'name', :label => '').should_not match /<\/label>/
        end

        it 'should not add a label when false' do
          @builder.send(method_name.to_sym, 'name', :label => false).should_not match /<\/label>/
        end
      end

      %w(select).each do |method_name|

        it "should not add a label when ''" do
          @builder.send(method_name.to_sym, 'name', [1,2], :label => '').should_not match /<\/label>/
        end

        it 'should not add a label when false' do
          @builder.send(method_name.to_sym, 'name', [1,2], :label => false).should_not match /<\/label>/
        end
      end
    end
  end # extras

  describe 'form actions' do
    context 'actions' do
      it 'adds additional block content' do
        @builder.actions do
          @builder.submit
        end.should match(/<div class=\"form-actions\">.*?<\/div>/)
      end
    end

    context 'submit' do
      it 'adds btn primary class if no class is defined' do
        @builder.submit.should match /class=\"btn btn-primary\"/
      end

      it 'allows for custom classes' do
        @builder.submit(:class => 'btn btn-large btn-success').should match /class=\"btn btn-large btn-success\"/
      end
    end

    context 'button' do
      it 'adds btn class if no class is defined' do
        @builder.button.should match /class=\"btn\"/
      end

      it 'allows for custom classes' do
        @builder.button(:class => 'btn btn-large btn-success').should match /class=\"btn btn-large btn-success\"/
      end
    end

    context 'cancel' do
      it 'creates a link with cancel btn class if no class is defined' do
        @builder.should_receive(:link_to).with(I18n.t('bootstrap_forms.buttons.cancel'), :back, :class => 'btn cancel').and_return("")
        @builder.cancel
      end

      it 'creates a link with custom classes when defined' do
        @builder.should_receive(:link_to).with(I18n.t('bootstrap_forms.buttons.cancel'), :back, :class => 'btn btn-large my-cancel').and_return("")
        @builder.cancel(:class => 'btn btn-large my-cancel')
      end

      it 'creates a link with a custom name when defined' do
        name = 'Back'
        @builder.should_receive(:link_to).with(name, :back, :class => 'btn cancel').and_return("")
        @builder.cancel(name)
      end
    end
  end # actions
end
