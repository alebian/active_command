module ActiveCommand
  module Exceptions
    class UnexistentDefaultType < StandardError
      def initialize(type)
        @type = type
        super("Unexistent default type: `#{type}`")
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
