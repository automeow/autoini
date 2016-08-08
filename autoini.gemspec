# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'autoini/version'

Gem::Specification.new do |spec|
  spec.name          = "autoini"
  spec.version       = Autoini::VERSION
  spec.authors       = ["Sam Boylett"]
  spec.email         = ["sam.boylett@alumni.york.ac.uk"]

  spec.summary       = %q{Parser / writer for INI files}
  spec.homepage      = "https://github.com/automeow/autoini"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
