# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'odk_aggregate/version'

Gem::Specification.new do |spec|
  spec.name          = "odk_aggregate"
  spec.version       = OdkAggregate::VERSION
  spec.authors       = ["Jonathan Salis"]
  spec.email         = ["jon@functionalimperative.com"]
  spec.description   = %q{An API wrapper to connect to ODK Aggregate}
  spec.summary       = %q{An API wrapper to connect to ODK Aggregate}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency 'faraday'
  spec.add_runtime_dependency 'faraday_middleware'
  spec.add_runtime_dependency 'faraday-digestauth'
  spec.add_runtime_dependency 'rash',               '~> 0.4'
  spec.add_runtime_dependency 'multi_xml'
end
