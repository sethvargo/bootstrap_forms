module BootstrapForms
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def generate_insall
      copy_file 'bootstrap_form_builder.rb', 'app/form_builders/bootstrap_form_builder.rb'
      copy_file 'bootstrap_forms.rb', 'config/initializers/bootstrap_forms.rb'
    end
  end
end