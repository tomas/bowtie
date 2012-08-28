module Bowtie

  def self.models
    DataMapper::Model.descendants.to_a - Bowtie.config.excluded_models
  end

  def self.search(model, q, page)
    query = []
    model.searchable_fields.each do |field|
      query << "#{model}.all(:#{field}.like => '%#{q}%')"
    end
    eval(query.join(' + ')).page(page, :per_page => PER_PAGE)
  end

  def self.get_many(model, params, page)
    add_paging(model.all(params), page)
  end

  def self.get_one(model, id)
    model.get(id)
  end

  def self.create(model, params)
    model.create(params)
  rescue DataObjects::IntegrityError
    model.new(params)
  end

  def self.get_associated(model, params)
    res = model.get(params[:id]).send(params[:association])
    # if model.associations[params[:association]].type == :many
    # 	add_paging(res, params)
    # end
  end

  # doesnt trigger validations or callbacks
  def self.update!(resource, params)
    resource.update!(params)
  end

  def self.update(resource, params)
    resource.update(params)
  end

  def self.add_paging(resources, page)
    resources.respond_to?(:page) ? resources.page(page, :per_page => PER_PAGE) : resources
  end

  def self.belongs_to_association?(assoc)
    assoc.class == DataMapper::Associations::ManyToOne::Relationship
  end

  def self.has_one_association?(assoc)
    assoc.class == DataMapper::Associations::OneToOne::Relationship
  end

  # i have to say this: datamapper sucks. when calling record.association.count
  # it actually fetches all the records, builds an array and then calls count on
  # that array.
  def self.get_count(record, association)
    association_key = "#{record.class.name.downcase}_#{record.class.primary_key}"
    begin
      repository.adapter.select("select count(*) from #{association} where #{association_key} = ?", record.primary_key)
    rescue DataObjects::SQLError => e # probably has_many :through => association
      ''
    end
  end

  # The property classes that the ORM
  def self.adapter_fields_registry
    {
      "DataMapper::Property::Text" => "textarea",
      "DataMapper::Property::String" => "text",
      "DataMapper::Property::Boolean" => "checkbox",
      "DataMapper::Property::Time" => "datetime"
    }
  end

  module Helpers

    def total_entries(resources)
      resources.respond_to?(:pager) ? resources.pager.total : resources.count
    end

    def show_pager(resources, path)
      q = request.path["/search"] ? "?model=#{params[:model]}&q=#{params[:q]}" : ""
      s = resources.pager.to_html(base_path + path + q) if resources.respond_to?(:pager)
    end

  end

  module ClassMethods

    def primary_key
      key.first.name
    end

    def model_associations
      return [] if relationships.nil? or relationships.empty?
      if relationships.first.is_a?(Array)
        return relationships
      else
        h = {}
        relationships.map {|r| h[r.name] = r }
        return h
      end
    end

    def field_names
      properties_field_names -
        self.excluded_fields +
        self.extra_fields
    end

    def properties_field_names
      self.properties.collect{|p| p.name }
    end

    def boolean_fields
      self.properties.map{|a| a.name if a.class == DataMapper::Property::Boolean}.compact
    end

    def searchable_fields
      self.properties.map{|a| a.name if a.class == DataMapper::Property::String}.compact
    end

    def subtypes
      begin
        self.validators.first.last.map{|a,b| b = {a.field_name => a.options[:set]} if a.class == DataMapper::Validate::WithinValidator}.compact
      rescue NoMethodError
        # puts ' -- dm-validations gem not included. Cannot check subtypes for class.'
        []
      end
    end

    def options_for_subtype(field)
      self.validators.first.last.map{|a| a.options[:set] if a.class == DataMapper::Validate::WithinValidator && a.field_name == field}.compact.reduce
    end

    def relation_keys_include?(property)
      self.relationships.named? property.to_sym
    end

    def excluded_fields
      []
    end

    def extra_fields
      []
    end

    def class_of property
      self.properties[property.to_sym].class
    end

  end

end

module DataMapper::Resource

  def primary_key
    send(self.class.primary_key)
  end

  unless defined?(:to_json)

    def to_json
      attributes.to_json
    end

  end

end
