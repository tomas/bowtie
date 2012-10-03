libdir = File.expand_path(File.dirname(__FILE__)) + '/bowtie'
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

if defined?(DataMapper)
	begin
		%w(dm-core dm-validations dm-aggregates dm-pager json adapters/datamapper).each {|lib| require lib}
	rescue Gem::LoadError => e
		raise Gem::LoadError, "Seems you have an outdated version of one of the following gems: dm-core dm-validations dm-aggregates dm-pager"
	rescue LoadError => e
		raise Gem::LoadError, "Error loading DataMapper gems. Make sure the all the following gems are available: dm-core dm-validations dm-aggregates dm-pager"
	end
elsif defined?(MongoMapper)
	%w(mongo_mapper adapters/mongomapper).each {|lib| require lib}
else
	raise Gem::LoadError, "No adapters found. You need to require MongoMapper (mongo_mapper) or DataMapper (dm-core) before requiring Bowtie."
end

%w(sinatra helpers core_extensions bowtie_config admin).each {|lib| require lib}
