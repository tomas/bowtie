module Bowtie

	PER_PAGE = 25

	class Admin < Sinatra::Base

		use Rack::Auth::Basic do |username, password|
			begin
				user, pass = ::BOWTIE_AUTH[:user], ::BOWTIE_AUTH[:pass]
			rescue NameError
				user, pass = 'admin', 'bowtie'
			end
			username == user && password == pass
		end

		use Rack::MethodOverride

		set :views, File.dirname(__FILE__) + '/views'

		helpers do
			include Helpers
		end

		get '/*.js|css|png|jpg|ico' do
			deliver_file or status 404
		end

		get '/' do
			# redirect '' results in an endless redirect on the current version of sinatra/rack
			redirect '/' + mappings.keys.first
		end

		get '' do
			redirect '/' + mappings.keys.first
		end

		get '/search*' do
			redirect('/' + params[:model] ||= '') if params[:q].nil? or params[:q].empty?
			@resources = Bowtie.search(model, params[:q], params[:page])
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

			redirect referer + '?error=doesnt+exist' if res.nil? or (res.is_a?(Array) and res.empty?)

			if res.is_a?(Array)
				@model = res.first.class
				@model.extend(ClassMethods) unless @model.respond_to?(:model_associations)
			  include_extension_to_model @model
				@resources = Bowtie.add_paging(res, params[:page])
				erb :index
			else
				@model = res.class
				@model.extend(ClassMethods) unless @model.respond_to?(:model_associations)
			  include_extension_to_model @model
				@resource = res
				erb :show
			end

		end

		put "/:model/:id" do
			if request.xhr? # dont pass through hooks or put the boolean stuff
				# if Bowtie.update!(resource, params[:resource].normalize)
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
