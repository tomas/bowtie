module Bowtie
  class Config

    attr_reader :excluded_models, :fields_registry

    FIELDS_REGISTRY = {
      "TrueClass" => "checkbox",
      "FalseClass" => "checkbox",
      "String" => "text",
      "Text" => "textarea"
    }

    def initialize
      @fields_registry = FIELDS_REGISTRY
    end

    ##
    # Models to exclude from Bowtie.models
    # Recives an array of Classes
    #
    # Example: exclude_models = [UserPosts, History]
    #
    def excluded_models= models=[]
      raise "Expeting an Array of models" unless models.kind_of? Array

      @excluded_models = models
    end

    ##
    # Map between property class name and html field type
    #
    def fields_registry= hash={}
      raise "Expecting a Hash" unless models.kind_of? Hash

      @fields_registry = hash
    end

  end

  def self.config
    @config ||= Config.new
  end

  module Models

    module Extensions
      # Add your model extensions under this namespace
      # Example:
      #   module Bowtie::Models::Extensions
      #     module User
      #       def to_option_text
      #         ..
      #       end
      #
      #       module ClassMethods
      #         def self.excluded_fields
      #           [:encrypted_password]
      #         end
      #       end
      #
      #       def self.included base
      #         base.extend ClassMethods
      #       end
      #     end
      #   end
    end

  end
end
