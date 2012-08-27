module Bowtie

	def self.models
		models = MongoMapper::Document.descendants.to_a.uniq -
      Bowtie.config.excluded_models
#		models.each {|m| models = models + m.subclasses}
#		models
	end

	def self.search(model, q, page)
		res = []
		model.searchable_fields.each do |field|
			res = res + add_paging(model.where(field.to_sym => /#{q}/i), page).all
		end
		res.uniq
	end

	def self.get_many(model, params, page)
		add_paging(model.where(params), page)
	end

	def self.get_one(model, id)
		model.find(id)
	end

	def self.create(model, params)
		model.create(params)
	end

	def self.get_associated(model, params)
		model.find(params[:id]).send(params[:association])
	end

	def self.add_paging(resources, page)
		resources.skip((page.to_i || 0)*PER_PAGE).limit(PER_PAGE).sort('id asc')
	end

	# doesnt trigger validations or callbacks
	def self.update!(resource, params)
		resource.update_attributes!(params)
	end

	def self.update(resource, params)
		resource.update_attributes(params)
	end

	def self.belongs_to_association?(assoc)
		assoc.class == MongoMapper::Plugins::Associations::BelongsToAssociation
	end

	def self.has_one_association?(assoc)
		assoc.class == MongoMapper::Plugins::Associations::OneAssociation
	end

	def self.get_count(record, association)
		record.send(association).count
	end

	module Helpers

		def total_entries(resources)
			resources.count
		end

		def get_page(counter)
			str = request.path["/search"] ? "&model=#{params[:model]}&q=#{params[:q]}" : ""
			i = (params[:page].to_i || 0) + counter
			i == 0 ? str : "?page=#{i}#{str}"
		end

		def show_pager(resources, path)
			path = base_path + path.gsub(/[?|&]page=\d+/,'') # remove page from path
			nextlink = "<li><a class='next' href='#{path}#{get_page(1)}'>Next &rarr;</a></li>"
			prevlink = "<li><a class='prev' href='#{path}#{get_page(-1)}'>&larr; Prev</a></li>"
			s = params[:page] ? prevlink + nextlink : nextlink
			"<ul class='pager'>" + s + "</ul>"
		end

	end

	module ClassMethods

		def primary_key
			'id'
		end

		def model_associations
			associations
		end

		def field_names
			self.keys.keys.collect { |f| f.to_sym } - self.excluded_fields
		end

		def boolean_fields
			s = []
			self.keys.each {|k,v| s << k if v.type == Boolean}
			s.compact
		end

		def searchable_fields
			s = []
			self.keys.each {|k,v| s << k if v.type == String && k != "_type"}
			s.compact
		end

		def subtypes
			s = []
			self.keys.each {|k,v| s << k if v.type.class == Array}
			s.compact
		end

		def options_for_subtype(field)
			self.keys[field].type
		end

		def relation_keys_include?(key)
			self.associations.map {|rel| true if key.to_sym == rel[0]}.reduce
		end

    def excluded_fields
      []
    end

	end

end

module MongoMapper::Document

	def primary_key
		send(self.class.primary_key)
	end

end
