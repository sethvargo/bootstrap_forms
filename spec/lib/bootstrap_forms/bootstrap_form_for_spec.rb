require 'spec_helper'

describe 'bootstrap_form_for' do
  describe 'default_form_builder' do
    it 'should be accessible' do
      BootstrapForms.should respond_to(:default_form_builder)
    end

    it 'should be the BootstrapForms form_builder by default' do
      BootstrapForms.default_form_builder.should == BootstrapForms::FormBuilder
    end

    context 'projects/new_without_summary_errors.html.erb', :type => :view do
      before do
        project = Project.new
        project.errors.add('name')
        assign :project, project
        render :file => 'projects/new_without_summary_errors', :layout => 'layouts/application', :handlers => [:erb]
      end

      it 'should not render the full error messages div' do
        rendered.should_not match /There were errors that prevented this Project from being saved/
      end
    end

    context 'when set to something else' do
      before do
        BootstrapForms.default_form_builder = MyCustomFormBuilder
      end

      it 'should be that other thing' do
        BootstrapForms.default_form_builder.should == MyCustomFormBuilder
      end

      describe 'projects/new.html.erb', :type => :view do
        before do
          assign :project, Project.new
          render :file => 'projects/new', :layout => 'layouts/application', :handlers => [:erb]
        end

        it 'should render with the other form builder' do
          # in other words, it shouldn't be wrapped with the bootstrap stuff
          rendered.should_not match /<div class=\"control-group\"><label class=\"control-label\" for=\"item_name\">Name<\/label><div class=\"controls\">.*<\/div><\/div>/
        end
      end
    end
  end
end
