
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "avrodrome/version"

Gem::Specification.new do |spec|
  spec.name          = "avrodrome"
  spec.version       = Avrodrome::VERSION
  spec.authors       = ["Adam Carlile"]
  spec.email         = ["hello@adamcarlile.com"]

  spec.summary       = "An in memory drop in replacement for an Avro Schema Registry"
  spec.homepage      = "https://github.com/adamcarlile/avrodrome"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "faker"
end
