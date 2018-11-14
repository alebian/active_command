class RequiredTest < ActiveCommand::Base
  required :parameter, type: Types::Array
end
