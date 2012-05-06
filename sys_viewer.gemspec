# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sys_viewer/version"

Gem::Specification.new do |s|
  s.name        = "sys_viewer"
  s.version     = SysViewer::VERSION
  s.authors     = ["Michaël Rigart"]
  s.email       = ["michael@netronix.be"]
  s.homepage    = "https://github.com/netronix/sys_viewer"
  s.summary     = %q{View system information}
  s.description = %q{View system information}

  s.required_ruby_version = ">= 1.9"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
