
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_command/version'
require 'date'

Gem::Specification.new do |spec|
  spec.name          = 'active_command'
  spec.version       = ActiveCommand::VERSION
  spec.authors       = ['alebian']
  spec.email         = ['alebezdjian@gmail.com']
  spec.date          = Date.today
  spec.summary       = ''
  spec.description   = ''
  spec.homepage      = 'https://github.com/alebian/active_command'
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.license       = 'Apache-2.0'

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.7'
  spec.add_development_dependency 'rubocop', '~> 1.14'
  spec.add_development_dependency 'byebug', '~> 11.1'
end
