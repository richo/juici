# vim: ft=ruby
#
require File.expand_path("../lib/juici/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "juici-interface"
  s.version     = Juici::VERSION
  s.authors     = ["Richo Healey"]
  s.email       = ["richo@psych0tik.net"]
  s.homepage    = "http://github.com/richo/juici"
  s.summary     = "Interface definition for JuiCI callbacks and API"
  s.description = s.summary

  s.files         = []
  s.files         = "lib/juici/interface.rb"
  s.files         << `git ls-files lib/juici/interface`.split("\n")
  s.files.flatten!
  s.require_paths = ["lib"]
  s.executables   = "juicic"
end


