require 'bundler'
source "https://rubygems.org"

if Bundler::VERSION =~ /(\d+)\.(\d+)\.(\d+)/
  major, minor, patch = Integer($1), Integer($2), Integer($3)
  major >= 1 && minor >= 2 && ruby('2.0.0')
else
  raise "Can't parse bundler version"
end

gemspec :name => "juici"
