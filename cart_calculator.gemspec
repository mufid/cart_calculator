Gem::Specification.new do |spec|
  spec.name          = "cart_calculator"
  spec.version       = "0.1.0"
  spec.authors       = ["Mufid Afif"]
  spec.email         = ["mufid.afif@gmail.com"]

  spec.summary       = %q{A shopping cart calculator for Acme Widget Co}
  spec.description   = %q{A proof of concept sales system that calculates cart totals with delivery charges and special offers}
  spec.homepage      = "https://github.com/yourusername/cart_calculator"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.4.4")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bigdecimal"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "yard", "~> 0.9"
end