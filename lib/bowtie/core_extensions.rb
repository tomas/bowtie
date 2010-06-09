class String

	def titleize
		self.capitalize.gsub('_',' ')
	end

	def singularize
		self.gsub(/ies/,'y').gsub(/s$/, '')
	end

	def pluralize
		self.gsub(/y$/,'ie') + "s"
	end

end

class Class

	def pluralize
		self.to_s.pluralize
	end

	def field_names
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
		self.relationships.map {|rel| true if property.to_sym == rel[1].child_key.first.name}.reduce
	end

end

class Hash

	def prepare_for_query(model)
		self.filter_inaccessible_in(model).include_missing_booleans_in(model).normalize
	end

	def filter_inaccessible_in(model)
		fields = model.field_names
		self.delete_if { |key,val| !fields.include?(key.to_sym) }
	end

	def include_missing_booleans_in(model)
		model.boolean_fields.each do |bool|
			self[bool] = false unless self.has_key?(bool.to_s)
		end
		self
	end

	# this is for checkboxes which give us a param of 'on' on the params hash
	def normalize
		replacements = { 'on' => true, '' => nil}
		normalized = {}
		self.each_pair do |key,val|
			normalized[key] = replacements.has_key?(val) ? replacements[val] : val
		end
		normalized
	end

end
