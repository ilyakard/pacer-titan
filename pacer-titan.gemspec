# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pacer-titan/version"

Gem::Specification.new do |s|
  s.name        = "pacer-titan"
  s.version     = Pacer::Titan::VERSION
  s.platform    = 'java'
  s.authors     = ["Ilya Kardailsky"]
  s.email       = ["ilya.kardailsky@gmail.com"]
  s.homepage    = "http://www.github.com"
  s.summary     = %q{Titan adapter for Pacer}
  s.description = s.summary

  s.add_dependency 'pacer', Pacer::Titan::PACER_REQ

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
