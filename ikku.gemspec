# frozen_string_literal: true

require_relative "lib/ikku/version"

Gem::Specification.new do |spec|
  spec.name          = "ikku"
  spec.version       = Ikku::VERSION
  spec.authors       = ["Ryo Nakamura"]
  spec.email         = ["r7kamura@gmail.com"]
  spec.summary       = "Discover haiku from text."
  spec.homepage      = "https://github.com/r7kamura/ikku"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "csv"
  spec.add_runtime_dependency "natto"
end
