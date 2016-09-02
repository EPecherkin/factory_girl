module FactoryGirl
  # @api private
  class Trait
    attr_reader :name, :definition

    def initialize(name, options = {}, &block)
      assert_valid_options(options)
      @name = name
      @block = block
      @definition = Definition.new(@name)
      @abstract = options[:abstract] || false

      proxy = FactoryGirl::DefinitionProxy.new(@definition)
      proxy.instance_eval(&@block) if block_given?
    end

    delegate :add_callback, :declare_attribute, :to_create, :define_trait, :constructor,
             :callbacks, :attributes, to: :@definition

    def names
      [@name]
    end

    def ==(other)
      name == other.name &&
        block == other.block
    end

    def abstract?
      @abstract
    end

    protected

    attr_reader :block

    def assert_valid_options(options)
      options.assert_valid_keys(:abstract)
    end
  end
end
