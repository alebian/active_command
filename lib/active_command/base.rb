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
        base_class_parameters[name] = {
          type: options[:type],
          required: true
        }
      end

      def optional(name, options = {})
        base_class_parameters[name] = {
          type: options[:type],
          required: false
        }
      end

      def before(&block)
        base_class_before_hooks << block
      end

      def after(&block)
        base_class_after_hooks << block
      end

      def base_class_parameters
        class_variable_get(:@@parameter_definitions)
      end

      def base_class_before_hooks
        class_variable_get(:@@before_hooks)
      end

      def base_class_after_hooks
        class_variable_get(:@@after_hooks)
      end
    end

    def initialize(options = {})
      # @before_hooks = []
      # @after_hooks = []
      @instance_parameters = {}
      initialize_values!(options)
      define_methods!
    end

    def run
      execute_before_hooks
      call
      execute_after_hooks
    end

    def call; end

    def execute_before_hooks
      self.class.class_variable_get(:@@before_hooks).each do |block|
        instance_exec(&block)
      end
    end

    def execute_after_hooks
      self.class.class_variable_get(:@@after_hooks).each do |block|
        instance_exec(&block)
      end
    end

    private

    def base_class_parameters
      self.class.class_variable_get(:@@parameter_definitions)
    end

    def initialize_values!(options = {})
      options.each do |key, value|
        @instance_parameters[key] = value
        check_type!(value, base_class_parameters[key][:type])
      end
    end

    def check_type!(object, type_definition)
      return if type_definition.nil?
      type = type_definition.is_a?(Symbol) ? DEFAULT_TYPES[type_definition] : type_definition
      raise Exceptions::UnexistentDefaultType, type_definition if type.nil?
      raise Exceptions::IncompatibleType.new(object, type) unless object.is_a?(type)
    end

    def define_methods!
      base_class_parameters.each_key do |name|
        define_singleton_method(name) { @instance_parameters[name] }
      end
    end
  end
end
