require "spec_helper"

describe "BootstrapForms::FormBuilder" do
  describe "with no options" do
    before(:each) do
      @project = Project.new
      @template = ActionView::Base.new
      @template.output_buffer = ""
      @builder = BootstrapForms::FormBuilder.new(:item, @project, @template, {}, proc {})
    end
    
    %w{email_field file_field number_field password_field range_field search_field text_field url_field text_area telephone_field phone_field}.each do |field|
      describe "#{field} wrapping" do
        before(:each) do
          @result = @builder.send(field, "name").to_s
        end
      
        it "starts with wrapping code" do
          @result.should match /^<div class=\"control-group\"><label class=\"control-label\" for=\"item_name\">Name<\/label><div class=\"controls\">/
        end
      
        it "ends with wrapping code" do
          @result.should match /<\/div><\/div>$/
        end
      end
    end
  end
end