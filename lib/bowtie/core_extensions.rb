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

	def searchable_fields
		self.properties.map{|a| a.name if a.type == String}.compact
	end

	def subtypes
		self.validators.first.last.map{|a,b| b = {a.field_name => a.options[:set]} if a.class == DataMapper::Validate::WithinValidator}.compact
	end

	def options_for_subtype(field)
		self.validators.first.last.map{|a| a.options[:set] if a.class == DataMapper::Validate::WithinValidator && a.field_name == field}.compact.reduce
	end

	def relation_keys_include?(property)
		self.relationships.map {|rel| true if property.to_sym == rel[1].child_key.first.name}.reduce
	end

end

class Hash

	# this is for checkboxes which give us a param of 'on' on the params hash
	def normalize
		normalized = {}
		self.each_pair {|k,v| normalized[k] = v == 'on' ? true : v }
		normalized
	end

end
