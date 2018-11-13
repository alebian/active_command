module ActiveCommand
  class Base
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
        check_type!(
          object: value,
          type: parameter_definitions[key][:type],
          is_required: parameter_definitions[key][:required]
        )
      end
    end

    def check_type!(object:, type:, is_required:)
      return if type.nil?
      return if !is_required && object.nil?
      type = type.is_a?(Symbol) ? DEFAULT_TYPES[type] : type
      raise Exceptions::UnexistentDefaultType.new(type) if type.nil?
      raise Exceptions::IncompatibleType.new(object, type) unless object.is_a?(type)
    end

    def define_parameter_getter_methods!
      parameter_definitions.each_key do |name|
        define_singleton_method(name) { @instance_parameters[name] }
      end
    end
  end
end
