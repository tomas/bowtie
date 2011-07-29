Gem::Specification.new do |s|
  s.name = %q{bowtie}
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tomás Pollak"]
  s.date = %q{2010-06-06}
  s.description = %q{Simple admin scaffold for MongoMapper and DataMapper models.}
  s.email = %q{tomas@forkhq.com}
  s.extra_rdoc_files = [ "lib/bowtie.rb", 
                         "lib/bowtie/admin.rb", 
                         "lib/bowtie/core_extensions.rb", 
                         "lib/bowtie/helpers.rb" ]

  s.files = [ "README.md", 
              "bowtie.gemspec", 
              "lib/bowtie.rb", 
              "lib/bowtie/adapters/datamapper.rb", 
              "lib/bowtie/adapters/mongomapper.rb", 
              "lib/bowtie/admin.rb", 
              "lib/bowtie/core_extensions.rb", 
              "lib/bowtie/helpers.rb", 
              "lib/bowtie/views/errors.erb", 
              "lib/bowtie/views/field.erb", 
              "lib/bowtie/views/flash.erb", 
              "lib/bowtie/views/form.erb", 
              "lib/bowtie/views/index.erb", 
              "lib/bowtie/views/layout.erb", 
              "lib/bowtie/views/new.erb", 
              "lib/bowtie/views/search.erb", 
              "lib/bowtie/views/show.erb", 
              "lib/bowtie/views/subtypes.erb",
              "lib/bowtie/views/table.erb", 
              "lib/bowtie/views/row.erb", 
              "lib/bowtie/public/css/bowtie.css", 
              "lib/bowtie/public/js/bowtie.js", 
              "lib/bowtie/public/js/jquery.tablesorter.pack.js", 
              "lib/bowtie/public/js/jquery.jeditable.pack.js" ]

  s.homepage = %q{http://github.com/tomas/bowtie}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Bowtie", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{bowtie}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Bowtie Admin Scaffold}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, [">= 0.9.4"])
    else
      s.add_dependency(%q<sinatra>, [">= 0.9.4"])
    end
  else
    s.add_dependency(%q<sinatra>, [">= 0.9.4"])
  end
end
