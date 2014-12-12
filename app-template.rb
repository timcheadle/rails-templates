require 'rbconfig'

def append_file_line(file, txt)
  append_file file, "#{txt}\n"
end

# Standardize on postgres
#   Check/assume logged-in user can create databases
#   Use min_warnings
#   config/database.yml.example and perform overwrite
#   Write to readme
#
gem "pg"

gem 'bootstrap-sass'
gem 'font-awesome-sass'
gem 'bootstrap_form', github: 'bootstrap-ruby/rails-bootstrap-forms'
gem 'hirb'
gem 'kaminari'
gem 'redcarpet'
gem 'seedbank'

gem_group :development, :test do
  gem 'rspec-rails'
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-awesome_print'
  gem 'guard-rspec', require: false
  gem 'guard-bundler'
  gem 'rb-fsevent'
end

gem_group :test do
  gem 'capybara'
  gem 'poltergeist'
  gem 'factory_girl_rails'
  gem 'launchy'
  gem 'database_cleaner'
end

#
# Environment
#
environment <<-APP_GENERATORS
  config.generators do |g|
    g.orm :active_record
    g.test_framework :rspec,
      :fixtures => true,
      :view_specs => false,
      :helper_specs => false,
      :routing_specs => false,
      :controller_specs => false,
      :request_specs => true
    g.fixture_replacement :factory_girl, :dir => "spec/factories"
  end
  config.time_zone = 'Eastern Time (US & Canada)'
APP_GENERATORS

#
# File utilities
#
def source_paths
  [File.join(File.expand_path(File.dirname(__FILE__)),'rails_root')] + Array(super)
end

def replace_file(filename)
  remove_file filename
  copy_file filename
end


#
# Files
#
replace_file '.gitignore'

# Remove turbolinks
gsub_file "Gemfile", /^gem\s+["']turbolinks["'].*$/,''

inside 'app' do
  inside 'helpers' do
    replace_file 'application_helper.rb'
  end
end

inside 'config' do
  remove_file 'database.yml'
  template 'database.yml'
end

inside 'spec/support' do
  copy_file 'capybara.rb'
  copy_file 'db_cleaner.rb'
  copy_file 'focus.rb'
end

#
# Setup
#
run "bundle install"

generate "rspec:install"
run "bundle exec guard init"
rake "db:create"
rake "db:migrate"

generate "controller welcome index"

route "root to: 'welcome#index'"

# Use SCSS instead of CSS
run "rm app/assets/stylesheets/application.css; touch app/assets/stylesheets/application.scss"

#
# Twitter Bootstrap
#
inside 'app' do
  inside 'assets' do
    inside 'javascripts' do
      append_file_line 'application.js', '//= require bootstrap'
      gsub_file "Gemfile", /\/\/=\s+require turbolinks.*$/, ''
    end

    inside 'stylesheets' do
      append_file_line 'application.scss', '@import "bootstrap-sprockets";'
      append_file_line 'application.scss', '@import "bootstrap";'
      append_file_line 'application.scss', '@import "font-awesome-sprockets";'
      append_file_line 'application.scss', '@import "font-awesome";'
    end
  end

  inside 'views' do
    inside 'layouts' do
      replace_file 'application.html.erb'
      copy_file '_header.html.erb'
      copy_file '_footer.html.erb'
    end

    inside 'welcome' do
      replace_file 'index.html.erb'
    end
  end
end

git :init
git add: "."
git commit: %Q{ -m 'Initial commit' }
