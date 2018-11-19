
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

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'rubocop', '~> 0.60'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.30'
end
