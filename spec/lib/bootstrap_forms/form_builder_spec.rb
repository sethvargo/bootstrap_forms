require 'spec_helper'

describe 'BootstrapForms::FormBuilder' do
  context 'given a setup builder' do
    before(:each) do
      @project = Project.new
      @template = ActionView::Base.new
      @template.output_buffer =''
      @builder = BootstrapForms::FormBuilder.new(:item, @project, @template, {}, proc {})
    end

    context 'with no options' do
      it_behaves_like 'a bootstrap form'
    end

    context 'with the :namespace option' do
      before(:each) do
        @builder.options[:namespace] = 'foo'
      end

      it 'prefixs HTML ids correctly' do
        @builder.text_field('name').should match /<(input) .*id="foo_item_name"/
      end
    end

    context 'with the :index option' do
      before(:each) do
        @builder.options[:index] = 69
      end

      it 'uses the correct :index' do
        @builder.text_field('name').should match /<input .*id="item_69_name"/
      end

      it 'does not add extraneous input data' do
        @builder.text_field('name').should_not match /<input .*index/
      end
    end

    context 'with the :namespace and :index options' do
      before(:each) do
        @builder.options[:namespace] = 'foo'
        @builder.options[:index] = 69
      end

      it 'uses the correct :index' do
        @builder.text_field('name').should match /<input .*id="foo_item_69_name"/
      end
    end

    context 'with :html options' do
      before(:each) do
        @builder.options[:html] = { :class => 'foo' }
      end

      it 'does not add the class to the elements' do
        @builder.text_field('name').should_not match /<input .*class="foo"/
      end
    end

    context 'without errors' do
      it 'returns empty string' do
        @builder.error_messages.should be_empty
      end
    end

    context 'errors' do
      before(:each) do
        @project.errors.add('name')
        @result = @builder.error_messages
      end

      it 'are wrapped in error div' do
        @result.should match /^<div class="alert alert-block alert-error validation-errors">.*<\/div>$/
      end

      it 'have a list with errors' do
        @result.should match /<ul><li>Name is invalid<\/li><\/ul>/
      end

      it 'have error title' do
        @result.should match /<h4 class="alert-heading">#{I18n.t('bootstrap_forms.errors.header', :model => Project.model_name.human)}<\/h4>/
      end

      it 'have error message on field' do
        @builder.text_field('name').should == "<div class=\"form-group error\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><input class=\"form-control\" id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><span class=\"help-inline error-message\">Name is invalid</span></div></div>"
      end

      it "joins passed error message and validation errors with ', '" do
        @builder.text_field('name', :error => 'This is an error!').should == "<div class=\"form-group error\"><label class=\"form-label\" for=\"item_name\">Name</label><div class=\"form-controls\"><input class=\"form-control\" id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /><span class=\"help-inline error-message\">This is an error!, Name is invalid</span></div></div>"
      end
    end

    context "errors with translations" do
      before(:all) { I18n.backend.store_translations I18n.locale, {:errors => {:format => "%{message}", :messages => {:invalid => "Nope"}}} }
      after(:all)  { I18n.backend.reload! }

      before(:each) do
        @project.errors.add('name')
        @result = @builder.error_messages
      end

      it 'use i18n format on field error message' do
        @builder.text_field('name').should match /<span class="help-inline error-message">Nope<\/span>/
      end
    end

    context 'an attribute with a PresenceValidator' do
      it 'adds the required attribute' do
        @builder.text_field('owner').should match /<input .*required="required"/
      end

      it "does not add the required attribute if required: false" do
        @builder.text_field('owner', :required => false).should_not match /<input .*required="required"/
      end

      it "not require if or unless validators" do
        @builder.text_field('if_presence').should_not match /<input .*required="required"/
        @builder.text_field('unless_presence').should_not match /<input .*required="required"/
      end

      it "should not be required if presence is on update and model is created" do
        @builder.text_field('update_presence').should_not match /<input .*required="required"/
      end

      it "should be required if on create and model is new" do
        @builder.text_field('create_presence').should match /<input .*required="required"/
      end

      it "should be required if presence is on update and model is not new" do
        @project.stub!(:persisted?).and_return(true)
        @builder.text_field('update_presence').should match /<input .*required="required"/
      end

      it "should not be required if on create and model is not new" do
        @project.stub!(:persisted?).and_return(true)
        @builder.text_field('create_presence').should_not match /<input .*required="required"/
      end
    end

    context 'submit' do
      it 'checks persistence of object' do
        @builder.submit.should match('Create Project')
      end
    end

    context 'button' do
      it 'checks persistence of object' do
        @builder.button.should match('Create Project')
      end
    end
  end

  context 'setup builder with a symbol' do
    before(:each) do
      @project = Project.new
      @template = ActionView::Base.new(nil, :item => @project)
      @template.output_buffer = ''
      @builder = BootstrapForms::FormBuilder.new(:item, nil, @template, {}, proc {})
    end

    it_behaves_like 'a bootstrap form'
  end
end

describe 'BootstrapForms::Helpers::FormTagHelper' do
  describe '#bootstrap_text_field_tag' do
    context 'with no method "validators_on"' do
      before(:each) do
        @non_active_record_object = {:attributes => [:id, :name]}
        @template = ActionView::Base.new
        @template.output_buffer = ""
        @builder = BootstrapForms::FormBuilder.new(:item, @non_active_record_object, @template, {}, proc {})
      end

      it 'returns an empty string with no errors' do
        @template.bootstrap_text_field_tag(@builder.object[:name]).should match /<div class="form-group">.*/
      end
    end
  end
end
