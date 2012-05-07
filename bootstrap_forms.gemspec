# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "bootstrap_forms"
  s.version     = "2.0.1"
  s.author      = "Seth Vargo"
  s.email       = "sethvargo@gmail.com"
  s.homepage    = "https://github.com/sethvargo/bootstrap_forms"
  s.summary     = %q{Bootstrap Forms makes Twitter's Bootstrap on Rails easy!}
  s.description = %q{Bootstrap Forms makes Twitter's Bootstrap on Rails easy to use by creating helpful form builders that minimize markup in your views.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec-rails", "~> 2.9.0"
  s.add_development_dependency "capybara", "~> 1.1.0"
  s.add_development_dependency "rake"
  s.add_development_dependency "rails", "~> 3.2.0"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "sqlite3"
end
