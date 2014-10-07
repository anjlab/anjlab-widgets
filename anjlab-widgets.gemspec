# -*- encoding: utf-8 -*-
require File.expand_path('../lib/anjlab-widgets/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Yury Korolev"]
  gem.email         = ["yury.korolev@gmail.com"]
  gem.description   = %q{Collection of UI widgets on top of anjlab-bootstrap-rails. Datepicker and Timepicker for now.}
  gem.summary       = %q{Collection of UI widgets on top of anjlab-bootstrap-rails}
  gem.homepage      = "https://github.com/anjlab/anjlab-widgets"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "anjlab-widgets"
  gem.require_paths = ["lib"]
  gem.version       = Anjlab::Widgets::VERSION

  gem.add_development_dependency 'rails', '>= 3.2'
  gem.add_development_dependency 'bundler', '>= 1.0'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'rspec-rails', '>= 2.9.0'
end
