# vim: ft=ruby

Gem::Specification.new do |s|
  s.name        = "juicy"
  s.version     = "0.0.0"
  s.authors     = ["Richo Healey"]
  s.email       = ["richo@psych0tik.net"]
  s.homepage    = "http://github.com/richo/juicy"
  s.summary     = "Minimal CI server with some support for dynamic"
  s.description = s.summary

  s.add_dependency "sinatra"
  s.add_dependency "json"
  s.add_dependency "mongo"
  s.add_dependency "mongoid"
  s.add_dependency "bson_ext"

  s.add_development_dependency "rake"
  s.add_development_dependency "mocha"
  s.add_development_dependency "rspec"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end


