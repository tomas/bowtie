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

### Simple relations in forms
Bowtie can resolve simple relations between models and presents the
ids in a dropdown.

For a nice data presentation, add a method called `to_option_text` in
the referred model.

    class User
      ...
      def to_option_text
        "#{id} - #{first_name} #{last_name}"
      end

      has n, :posts
    end

    class Post
      ...
      belongs_to :user
    end

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
