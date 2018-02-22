require 'active_command/exceptions'
require 'active_command/base'
require 'active_command/version'

module ActiveCommand
  DEFAULT_TYPES = {
    string: String,
    integer: Integer,
    array: Array,
    hash: Hash
  }.freeze
end
