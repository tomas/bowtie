module Bowtie

	PER_PAGE = 25

	class Admin < Sinatra::Base

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
			@models = Bowtie.models
		end

		get '/*.js|css|png|jpg' do
			deliver_file or status 404
		end

		get '/' do
		  # redirect '' results in an endless redirect on the current version of sinatra/rack
			redirect '/' + @models.first.linkable
		end

		get '' do
			redirect '/' + @models.first.linkable
		end

		get '/search*' do
			redirect('/' + params[:model] ||= '') if params[:q].blank?
			@resources = Bowtie.search(clean_params, params[:page])
			@subtypes = model.subtypes
			erb :index
		end

		get "/:model" do
			@resources = Bowtie.get_many(model, clean_params, params[:page])
			@subtypes = model.subtypes
			erb :index
		end

		get "/:model/new" do
			@resource = model.new
			erb :new
		end

		post "/:model" do
			@resource = Bowtie.create(model, params[:resource].prepare_for_query(model))
			if @resource.valid? and @resource.save
				redirect "/#{model.linkable}?notice=created"
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
			res = Bowtie.get_associated(model, params)

			redirect('/' + model.linkable + '?error=doesnt+exist') if res.nil? or (res.is_a?(Array) and res.empty?)

			if res.is_a?(Array)
				@resources = Bowtie.add_paging(res, params[:page])
				erb :index
			else
				@resource = res
				erb :show
			end

		end

		put "/:model/:id" do
			if request.xhr? # dont pass through hooks or put the boolean stuff
				# if Bowtie.update!(resource, params[:resource].normalize)
				puts params[:resource].inspect
				if Bowtie.update!(resource, params[:resource].filter_inaccessible_in(model).normalize)
					resource.to_json
				else
					false
				end
			else # normal request
				if Bowtie.update(resource, params[:resource].prepare_for_query(model))
					redirect("/#{model.linkable}/#{params[:id]}?notice=updated")
				else
					@resource = resource
					erb :show
				end
			end
		end

		delete "/:model/:id" do
			if resource.destroy
				redirect "/#{model.linkable}?notice=destroyed"
			else
				redirect "/#{model.linkable}/#{params[:id]}?error=not+destroyed"
			end
		end

	end

end
