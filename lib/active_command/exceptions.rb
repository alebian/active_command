module ActiveCommand
  module Exceptions
    class MissingRequiredParameter < StandardError
      def initialize(name)
        @name = name
        super("Required parameter '#{@name}' is missing.")
      end
    end

    class IncompatibleType < StandardError
      def initialize(object, expected)
        @object = object
        @expected = expected
        super("Incompatible type of #{object}, expected: `#{expected}` got: `#{object.class}`")
      end
    end
  end
end
