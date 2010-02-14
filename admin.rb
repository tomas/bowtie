module Silk

	%w(sinatra dm-core dm-aggregates dm-pager lib/silk/lib/helpers lib/silk/lib/core_extensions).each {|lib| require lib}

	class Admin < Sinatra::Base

		PER_PAGE = 25

		use Rack::Auth::Basic do |username, password|
			username == 'admin' && password == 'admin'
		end

		use Rack::MethodOverride

		set :views, File.dirname(__FILE__) + '/views'

		helpers do
			include Helpers
		end

		before do
			@app_name = ENV['APP_NAME'] ? [self.class.name, ENV['APP_NAME']].join(' > ') : self.class.name
			@models = DataMapper::Model.descendants.to_a
		end

		get '/*.js|css|png|jpg' do
			deliver_file or status 404
		end

		get '/' do
			redirect ''
		end

		get '' do
			redirect '/' + @models.first.pluralize
		end

		get '/search*' do
			redirect('/' + params[:model] ||= '') if params[:q].blank?
			q1, q2 = [], []
			@env['rack.request.query_hash'].each do |key, val|
				next if ['model','q'].include?(key)
				q1 << "#{model}.all(:#{key} => '#{val}')"
			end
			model.searchable_fields.each do |field|
				q2 << "#{model}.all(:#{field}.like => '%#{params[:q]}%')"
			end
			query = q1.any? ? [q1.join(' & '), q2.join(' + ')].join(' & ') : q2.join(' + ')
			@resources = eval(query).page(params[:page], :per_page => PER_PAGE)
			@subtypes = model.subtypes
			erb :index
		end

		get "/:model" do
			filter = @env['rack.request.query_hash'].delete_if{|a| ['page', 'message'].include?(a)}
			@resources = model.all().page(params[:page], :per_page => PER_PAGE)
			@subtypes = model.subtypes
			erb :index
		end

		get "/:model/new" do
			@resource = model.new
			erb :new
		end

		post "/:model" do
			@resource = model.create(params[:resource])
			if @resource.valid? and @resource.save
				redirect "/#{model.pluralize}?message=created"
			else
				erb :new
			end
		end

		get "/:model/:id" do
			@resource = resource
			erb :show
		end

		get "/:model/:id/:association" do
			@title = "#{params[:association].titleize} for #{model.to_s.titleize} ##{params[:id]}"
			r = model.get(params[:id]).send(params[:association])
			if r.respond_to?(:page)
				@resources = r.page(params[:page], :per_page => PER_PAGE)
				erb :index
			else
				@resource = r
				erb :show
			end
		end

		put "/:model/:id" do
			if resource.update(params[:resource])
				redirect "/#{model.pluralize}/#{params[:id]}?message=saved"
			else
				redirect "/#{model.pluralize}/#{params[:id]}?message=not+saved"
			end
		end

		delete "/:model/:id" do
			if resource.destroy
				redirect "/#{model.pluralize}?message=destroyed"
			else
				redirect "/#{model.pluralize}/#{params[:id]}?message=not+destroyed"
			end
		end
	end

end
