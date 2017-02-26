# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sbif_chile/version'

Gem::Specification.new do |spec|
  spec.name          = "sbif_chile"
  spec.version       = SbifChile::VERSION
  spec.authors       = ["jnka9"]
  spec.email         = ["jnkarlos.c@gmail.com"]

  spec.summary       = %q{Sbif Chile Api.}
  spec.description   = %q{obtene informacion financiera SBIF.}
  spec.homepage      = "https://github.com/nosenadayo/sbif_chile.git"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dotenv"
  spec.add_dependency "httparty", "~> 0.14.0"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry-byebug", "~> 3.4.2"
end
