
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "shuffix/version"

Gem::Specification.new do |spec|
  spec.name          = "shuffix"
  spec.version       = Shuffix::VERSION
  spec.authors       = ["pranc1ngpegasus"]
  spec.email         = ["temma.fukaya@mokmok.dev"]

  spec.summary       = %q{Randomize test fixtures to ensure order-independent tests}
  spec.description   = %q{A Ruby gem that randomizes the order of test fixtures for RSpec and Minitest, helping to ensure your application logic handles unordered data correctly. Particularly useful for applications using NewSQL databases where ORDER BY may be unreliable due to sharding.}
  spec.homepage      = "https://github.com/pranc1ngpegasus/shuffix"

  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/pranc1ngpegasus/shuffix"
    spec.metadata["changelog_uri"] = "https://github.com/pranc1ngpegasus/shuffix/blob/main/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.17"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
