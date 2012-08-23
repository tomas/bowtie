module Bowtie
  class Config

    attr_reader :excluded_models

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
  end

  def self.config
    @config ||= Config.new
  end

  module Models

    module Extensions
      # Add your model extensions here
      # Example:
      #   module Bowtie::Models::Extensions
      #     module User
      #       include BasicExtension
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
