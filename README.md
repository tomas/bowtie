## Bowtie: Simple admin scaffold for your MongoMapper & DataMapper models

Bowtie reads the information on your models and creates a nice panel in which you can view, edit and destroy records easily.

## How does it look?

Glad you asked:

![Bowtie!](https://github.com/tomas/bowtie/raw/master/screenshot.png)

## Installation

Include it in your Gemfile and update your bundle:

    source 'rubygems.org'
    ..
    gem 'bowtie'
  
Or install it by hand:

    $ (sudo) gem install bowtie

## Configuration

### Sinatra
Mount Bowtie wherever you want by editing your `config.ru` file, after loading your models. You can optionally include the admin/pass combination for the panel.

    require 'my_app' # models are loaded
    require 'bowtie'

    map "/admin" do
      BOWTIE_AUTH = {:user => 'admin', :pass => '12345'}
      run Bowtie::Admin
    end

    map '/' do
      run MyApp
    end

### Rails 3
Mount Bowtie in your `config/routes.rb` file with the new Rails 3 mount function. You can also optionally include the admin/pass combination for the panel.

    Rails::Application.routes.draw.do
        # your other routes
        BOWTIE_AUTH = {:user => 'admin', :pass => '12345'}
        mount Bowtie::Admin, :at => '/admin'
    end

Additionally you need to make sure that all models have been loaded because Rails only models them on demand and Bowtie only sees loaded models. Paste this into a new initializer `config/initializers/bowtie.rb`

    Dir[Rails.root + 'app/models/**/*.rb'].each do |path|
        require path
    end

### Customizing Bowtie
The bowtie customization can be achived through Bowtie::Models::Extensions.
You only need to add a module with the same name of the model.

`model/database.rb`

    class User
      include DataMapper::Resource
      ...
    end

`my_bowtie_customization.rb`

    module Bowtie::Models::Extensions::User
      ...
    end

Example explanation: Bowtie will include and extend the User model
with Bowtie::Models::Extensions::User on runtime.

For this customization you must require the bowtie customization after
requiring the bowtie gem.

    require 'my_app' # models are loaded
    require 'bowtie'
    require 'my_bowtie_customization'

    map "/admin" do
      BOWTIE_AUTH = {:user => 'admin', :pass => '12345'}
      run Bowtie::Admin
    end

    map '/' do
      run MyApp
    end


Bowtie can resolve simple relations between models and presents the
ids in a dropdown.

For a nice data presentation, add a method called `to_option_text` in the referred model.

`database.rb`

    class Comment
      ...
      belongs_to :post
    end

    class Post
      ...
      has n, :comments
    end

`my_bowtie_customization.rb`

    module Bowtie::Models::Extensions::Post
      def to_option_text
        "#{id} - #{name}"
      end
    end

Model fields can be excluded. The excluded fields will not be shown by
bowtie.

`my_bowtie_customization.rb`

    module Bowtie::Models::Extensions::User
      module ClassMethods
        def excluded_fields
          [:encrypted_password]
        end
      end

      def self.included base
        base.extend ClassMethods
      end
    end

Model exclusion.

`my_bowtie_customization.rb`

    Bowtie.config.excluded_models = [UserPost, UserPayment]

Registering new clases for input types.

`my_bowtie_customization`

    Bowtie.config.fields_registry = {"Paperclip::Attachment" => "file", "String" => "file"}

For adding your link to the footer.

`my_bowtie_customization.rb`

    Bowtie.config.footer = { href: 'http://....com', text: 'Footer Text' }

### Try it out!
Now you can go to /admin in your app's path and try out Bowtie using your user/pass combination. If not set, it defaults to admin/bowtie.

## Important notes

Bowtie requires a few gems but they're not included in the gemspec to prevent forcing your from installing unneeded gems. Therefore you need to make sure that Bowtie will have the following gems to work with: 

For MongoMapper models:
 
 * mongo_mapper
 * bson_ext (not required, but recommended)

For DataMapper models: 

 * dm-core
 * dm-validations
 * dm-aggregates
 * dm-pager

Note: From version 0.3, Bowtie is meant to be used from DataMapper 1.0.0 on. For previous versions of DM please install with -v=0.2.5.

## Copyright

(c) 2010-2012 - Tomás Pollak for Fork Ltd. Released under the MIT license.
