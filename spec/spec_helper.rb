require 'simplecov'
SimpleCov.start

require 'active_command'
require 'byebug'

require_relative 'support/after_test'
require_relative 'support/before_test'
require_relative 'support/complete_test'
require_relative 'support/optional_test'
require_relative 'support/required_test'
