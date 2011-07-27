module Bowtie

	class Admin < Sinatra::Base

		PER_PAGE = 25

		use Rack::Auth::Basic do |username, password|
			begin
				user = ::BOWTIE_AUTH[:user]
				pass = ::BOWTIE_AUTH[:pass]
			rescue NameError
				user = 'admin'
				pass = 'bowtie'
			end
			username == user && password == pass
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
		  # redirect '' results in an endless redirect on the current version of sinatra/rack
			redirect '/' + @models.first.pluralize
		end

		get '' do
			redirect '/' + @models.first.pluralize
		end

		get '/search*' do
			redirect('/' + params[:model] ||= '') if params[:q].blank?
			query1, query2 = [], []
			clean_params.each do |key, val|
				query1 << "#{model}.all(:#{key} => '#{val}')"
			end
			model.searchable_fields.each do |field|
				query2 << "#{model}.all(:#{field}.like => '%#{params[:q]}%')"
			end
			query = query1.any? ? [query1.join(' & '), query2.join(' + ')].join(' & ') : query2.join(' + ')
			@resources = eval(query).page(params[:page], :per_page => PER_PAGE)
			@subtypes = model.subtypes
			erb :index
		end

		get "/:model" do
			@resources = model.all(clean_params).page(params[:page], :per_page => PER_PAGE)
			@subtypes = model.subtypes
			erb :index
		end

		get "/:model/new" do
			@resource = model.new
			erb :new
		end

		post "/:model" do
			@resource = model.create(params[:resource].prepare_for_query(model))
			if @resource.valid? and @resource.save
				redirect "/#{model.pluralize}?notice=created"
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
			res = model.get(params[:id]).send(params[:association])
			if res.respond_to?(:page)
				@resources = res.page(params[:page], :per_page => PER_PAGE)
				erb :index
			else
				redirect('/' + model.to_s + '?error=doesnt+exist') unless res
				@resource = res
				erb :show
			end
		end

		put "/:model/:id" do
			if request.xhr? # dont pass through hooks or put the boolean stuff
				if resource.update!(params[:resource].filter_inaccessible_in(model).normalize)
					resource.to_json
				else
					false
				end
			else # normal request
				if resource.update(params[:resource].prepare_for_query(model))
					redirect("/#{model.pluralize}/#{params[:id]}?notice=updated")
				else
					@resource = resource
					erb :show
				end
			end
		end

		delete "/:model/:id" do
			if resource.destroy
				redirect "/#{model.pluralize}?notice=destroyed"
			else
				redirect "/#{model.pluralize}/#{params[:id]}?error=not+destroyed"
			end
		end
	end

end
