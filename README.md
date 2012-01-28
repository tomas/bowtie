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
