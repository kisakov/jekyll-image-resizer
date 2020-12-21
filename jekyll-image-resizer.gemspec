# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll-image-resizer/version'

Gem::Specification.new do |spec|
  spec.name          = "jekyll-image-resizer"
  spec.version       = Jekyll::ImageResizer::VERSION
  spec.authors       = ["kisakov"]
  spec.email         = ["isakov90@gmail.com"]

  spec.summary       = %q{jekyll image resizer plugin}
  spec.description   = %q{Resize images with simple command}
  spec.homepage      = "http://github.com/kisakov/jekyll-image-resizer"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'jekyll', '>= 3.5', '< 5.0'
  spec.add_dependency 'mini_magick'
  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", "~> 13.0"
end
