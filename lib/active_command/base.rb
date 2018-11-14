require 'dry-types'

module ActiveCommand
  class Base
    module Types
      include Dry::Types.module
    end

    def self.inherited(base)
      base.class_variable_set(:@@parameter_definitions, {})
      base.class_variable_set(:@@before_hooks, [])
      base.class_variable_set(:@@after_hooks, [])
      base.class_eval { extend ClassMethods }
    end

    module ClassMethods
      def call(options = {})
        instance = new(options)
        instance.run
        instance
      end

      def required(name, options = {})
        parameter_definitions[name] = {
          type: options[:type],
          required: true
        }
      end

      def optional(name, options = {})
        parameter_definitions[name] = {
          type: options[:type],
          required: false
        }
      end

      def before(&block)
        before_hooks << block
      end

      def after(&block)
        after_hooks << block
      end

      def parameter_definitions
        class_variable_get(:@@parameter_definitions)
      end

      def before_hooks
        class_variable_get(:@@before_hooks)
      end

      def after_hooks
        class_variable_get(:@@after_hooks)
      end
    end

    def initialize(options = {})
      initialize_values!(options) # TODO: deep_dup parameters
      define_parameter_getter_methods!
    end

    def run
      execute_before_hooks
      call
      execute_after_hooks
    end

    def call; end

    def execute_before_hooks
      before_hooks.each do |block|
        instance_exec(&block)
      end
    end

    def execute_after_hooks
      after_hooks.each do |block|
        instance_exec(&block)
      end
    end

    private

    def parameter_definitions
      self.class.class_variable_get(:@@parameter_definitions)
    end

    def before_hooks
      self.class.class_variable_get(:@@before_hooks)
    end

    def after_hooks
      self.class.class_variable_get(:@@after_hooks)
    end

    def initialize_values!(options = {})
      @instance_parameters = parameter_definitions.each_key.each_with_object({}) do |key, hash|
        hash[key] = options[key]
      end

      @instance_parameters.each do |key, value|
        definition = parameter_definitions[key]
        check_type!(
          key: key, object: value, type: definition[:type], is_required: definition[:required]
        )
      end
    end

    # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def check_type!(key:, object:, type:, is_required:)
      raise Exceptions::MissingRequiredParameter, key if is_required && object.nil?
      return if type.nil? || object.nil?

      if type.respond_to?(:try)
        raise Exceptions::IncompatibleType.new(object, type.name) if type.try(object).failure?
      else
        raise Exceptions::IncompatibleType.new(object, type) unless object.is_a?(type)
      end
    end
    # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    def define_parameter_getter_methods!
      parameter_definitions.each_key do |name|
        define_singleton_method(name) { @instance_parameters[name] }
      end
    end
  end
end
