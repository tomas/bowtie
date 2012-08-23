module Bowtie
  class Config

    attr_reader :excluded_models

    def excluded_models= models
      raise "Expeting an Array of models" unless models.kind_of? Array

      @excluded_models = models
    end
  end

  def self.config
    @config ||= Config.new
  end
end
