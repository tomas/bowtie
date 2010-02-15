module Bowtie

	module Helpers

		def deliver_file
			file = File.expand_path(File.dirname(__FILE__)) + "/../public/#{@env['PATH_INFO']}"
			return false unless File.exist?(file)
			content_type(Rack::Mime::MIME_TYPES[File.extname(@env['PATH_INFO'])], :charset => 'utf-8')
			File.read(file)
		end

		def base_path
			env['SCRIPT_NAME']
		end

		# Sinatra's redirect is not adding path prefix. Seems like a bug to me.
		def redirect(uri, *args)
			super base_path + uri.downcase, *args
		end

		def partial(name, *args)
			erb(name, :layout => false, *args)
		end

		def get_model_class
			begin
				Kernel.const_get(params[:model].singularize.capitalize)
			rescue NameError
				halt 404, "Model not found!"
			end
		end

		def model
			@model ||= get_model_class
		end

		def resource
			@resource ||= model.get(params[:id]) or halt(404, 'Resource not found!')
		end

		def current_model
			model
		end

		def model_path(m = current_model)
			string = m.name || m
			base_path + '/' + string.to_s.pluralize.downcase
		end

		def url_for(object)
			model_path(object.class) + '/' + object.id.to_s
		end

	end

end
