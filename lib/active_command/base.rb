module ActiveCommand
  class Base
    def self.inherited(base)
      base.class_variable_set(:@@parameters, {})
      base.class_variable_set(:@@before_hooks, [])
      base.class_variable_set(:@@after_hooks, [])
      base.class_eval { extend ClassMethods }
    end

    module ClassMethods
      def call(options = {})
        instance = new(options)
        execute_before_hooks
        instance.call
        execute_after_hooks
        instance
      end

      def required(name, options = {})
        base_class_parameters[name] = {
          type: options[:type],
          required: true
        }
        define_method(name) { @parameters[name] }
      end

      def optional(name, options = {})
        base_class_parameters[name] = {
          type: options[:type],
          required: false
        }
        define_method(name) { @parameters[name] }
      end

      def before(&block)
        base_class_before_hooks << block
      end

      def after(&block)
        base_class_after_hooks << block
      end

      def base_class_parameters
        class_variable_get(:@@parameters)
      end

      def base_class_before_hooks
        class_variable_get(:@@before_hooks)
      end

      def base_class_after_hooks
        class_variable_get(:@@after_hooks)
      end

      def execute_before_hooks
        base_class_before_hooks.each(&:call)
      end

      def execute_after_hooks
        base_class_after_hooks.each(&:call)
      end
    end

    def initialize(options = {})
      # @before_hooks = []
      # @after_hooks = []
      @parameters = {}
      initialize_values!(options)
    end

    private

    def base_class_parameters
      self.class.class_variable_get(:@@parameters)
    end

    def initialize_values!(options = {})
      options.each do |key, value|
        @parameters[key] = value
        check_type!(value, base_class_parameters[key][:type])
      end
    end

    def check_type!(object, type_definition)
      return if type_definition.nil?
      type = type_definition.is_a?(Symbol) ? DEFAULT_TYPES[type_definition] : type_definition
      raise Exceptions::UnexistentDefaultType, type_definition if type.nil?
      raise Exceptions::IncompatibleType.new(object, type) unless object.is_a?(type)
    end
  end
end
