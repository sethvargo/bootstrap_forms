module BootstrapForms
	class Railtie < ::Rails::Railtie
		config.after_initialize do |app|
			require 'bootstrap_forms/initializer'
		end
		
		initializer 'bootstrap_forms.initialize' do |app|
			
		end
	end
end