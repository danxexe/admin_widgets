# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "admin_widgets/version"

Gem::Specification.new do |s|
  s.name        = "admin_widgets"
  s.version     = AdminWidgets::VERSION
  s.authors     = ["DanX~"]
  s.email       = ["danx.exe@gmail.com"]
  s.homepage    = "http://www.mobvox.com.br"
  s.summary     = "Awesome Admin Widgets"
  s.description = "Super Awesome Admin Widgets"

  s.rubyforge_project = "admin_widgets"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"

  s.add_runtime_dependency "apotomo"
end
