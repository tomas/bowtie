libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

%w(sinatra dm-core dm-aggregates dm-pager bowtie/helpers bowtie/core_extensions bowtie/admin).each {|lib| require lib}

begin
	repository(:default).adapter
rescue DataMapper::RepositoryNotSetupError
	puts ' ** You need to set up your DataMapper adapter for Bowtie to work. **'
end
