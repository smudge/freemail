# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'freemail/version'

Gem::Specification.new do |spec|
  spec.name          = 'freemail'
  spec.version       = Freemail::VERSION
  spec.authors       = ['smudge']
  spec.email         = ['nathan@ngriffith.com']

  spec.summary       = %w(A ruby implementation of the npm 'freemail' module)
  spec.description   = <<-END
    A ruby implementation of the npm 'freemail' module, providing a database of
    free and disposable email domains.
  END
  spec.homepage      = 'https://github.com/smudge/freemail'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'
end
