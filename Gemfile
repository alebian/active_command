source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in active_command.gemspec
gemspec

group :development do
  gem 'byebug', '~> 10.0'
end

group :test do
  gem 'codeclimate-test-reporter', '~> 1.0'
  gem 'rspec', '~> 3.8'
  gem 'rubocop-rspec', '~> 1.30'
  gem 'rubocop', '~> 0.60'
  gem 'simplecov', '~> 0.16', require: false
end
