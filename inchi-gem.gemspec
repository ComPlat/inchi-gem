$:.unshift File.expand_path('../lib', __FILE__)
require 'inchi-gem/version'

Gem::Specification.new do |s|
  s.name = "inchi-gem"
  s.version = InChIGem::GEMVERSION

  s.authors = ["An Nguyen"]
  s.date = %q{2021-03-01}
  s.description = %q{Ruby gem for InChI}
  s.email = ["caman.nguyenthanh@gmail.com"]
  s.homepage = %q{http://github.com/complat/inchi-gem}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{InChIGem!}
  s.license = "LGPL-2.1"
  s.test_files = ["test/test_inchi_gem.rb"]

  s.files = %w{Rakefile lib/inchi-gem.rb lib/inchi-gem/version.rb}
  s.extensions = ['ext/inchi-gem/extconf.rb']
end
