# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'texttube/baby/version'

Gem::Specification.new do |spec|
  spec.name          = "texttube_baby"
  spec.version       = TextTube::Baby::VERSION
  spec.authors       = ["Iain Barnett"]
  spec.email         = ["iainspeed@gmail.com"]
  spec.summary       = "Some useful filters for markdown that I use in my blogs"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/yb66/TextTubeBaby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
	spec.add_dependency "texttube"
  spec.add_dependency "nokogiri"
  spec.add_dependency "coderay"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
