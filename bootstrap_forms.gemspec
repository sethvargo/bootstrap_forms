# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "bootstrap-forms"
  s.version     = "0.0.3"
  s.author      = "Seth Vargo"
  s.email       = "sethvargo@gmail.com"
  s.homepage    = "https://github.com/sethvargo/bootstrap_forms"
  s.summary     = %q{Bootstrap Forms makes Twitter's Bootstrap on Rails easy!}
  s.description = %q{Bootstrap Forms makes Twitter's Bootstrap on Rails easy to use by creating helpful form builders that minimize markup in your views.}

  s.rubyforge_project = "bootstrap-forms"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
