require "spec_helper"

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
        end
      end
    
      describe "text_area" do
        before(:each) do
          @result = @builder.text_area "name"
        end
      
        it "is wrapped" do
          @result.should match /^<div class=\"control-group\"><label class=\"control-label\" for=\"item_name\">Name<\/label><div class=\"controls\">.*<\/div><\/div>$/
        end
   
        it "has textarea input" do
          @result.should match /<textarea.*><\/textarea>/
        end      
      end
    
      describe "check_box" do
        it "generates wrapped input" do
          @builder.check_box("name").should == "<div class=\"control-group\"><div class=\"controls\"><label class=\"checkbox\" for=\"item_name\"><input name=\"item[name]\" type=\"hidden\" value=\"0\" /><input id=\"item_name\" name=\"item[name]\" type=\"checkbox\" value=\"1\" />Name</label></div></div>"
        end
      end
    
      (%w{email file number password range search text url }.map{|field| ["#{field}_field",field]} + [["telephone_field", "tel"], ["phone_field", "tel"]]).each do |field, type|
        describe "#{field}" do
          before(:each) do
            @result = @builder.send(field, "name")
          end
      
          it "is wrapped" do
            @result.should match /^<div class=\"control-group\"><label class=\"control-label\" for=\"item_name\">Name<\/label><div class=\"controls\">.*<\/div><\/div>$/
          end
   
          it "has an input of type: #{type}" do
            @result.should match /<input.*type=["#{type}"]/
          end
        end
      end
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
          @builder.text_field(:name, :error => 'This is an error!').should == "<div class=\"control-group error\"><label class=\"control-label\" for=\"item_name\">Name</label><div class=\"controls\"><input id=\"item_name\" name=\"item[name]\" size=\"30\" type=\"text\" /></div></div>"
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
      end
    end # extras
    
  end # setup builder
  
end