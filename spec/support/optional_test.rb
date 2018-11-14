class OptionalTest < ActiveCommand::Base
  optional :parameter, type: Types::Array
end
