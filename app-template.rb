def append_file_line(file, txt)
  append_file file, "#{txt}\n"
end

#
# Options
#
install_devise = yes?("Do you want to use Devise?")

# Standardize on postgres
#   Check/assume logged-in user can create databases
#   Use min_warnings
#   config/database.yml.example and perform overwrite
#   Write to readme
#
gem "pg"

gem 'devise' if install_devise
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

def replace_file(source, dest=nil)
  copy_file source, dest, force: true
end

def replace_template(source, dest=nil)
  template source, dest, force: true
end


#
# Standard Files
#
replace_file '.gitignore'

inside 'app' do
  inside 'helpers' do
    replace_file 'application_helper.rb'
  end
end

inside 'config' do
  replace_template 'database.yml'
end


# Remove turbolinks, coffeescript
comment_lines "Gemfile", /turbolinks/
comment_lines "Gemfile", /coffee-rails/

#
# Setup
#
run "bundle install"
generate "rspec:install"
run "bundle exec guard init"

generate "controller welcome index"
route "root to: 'welcome#index'"

#
# rspec
#
run 'mkdir spec/features'

inside 'spec' do
  uncomment_lines 'rails_helper.rb', Regexp.new(Regexp.escape('Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }'))

  inside 'support' do
    replace_file 'capybara.rb'
    replace_file 'db_cleaner.rb'
    replace_file 'factory_girl.rb'
    replace_file 'focus.rb'
  end
end


#
# Devise
#
if install_devise
  generate "devise:install"
  generate "devise User"
  generate "devise:views"
  environment "config.action_mailer.default_url_options = {host: 'localhost:3000'}", env: 'development'

  inside 'spec' do
    replace_file 'factories/users.rb'
    replace_file 'features/login_spec.rb'
    replace_file 'models/user_spec.rb'
    replace_file 'support/devise.rb'
  end
end

#
# Database stuff
#
rake "db:create:all"
rake "db:migrate"


#
# Twitter Bootstrap
#
inside 'app' do
  inside 'assets' do
    inside 'javascripts' do
      append_file_line 'application.js', '//= require bootstrap'
      gsub_file "application.js", /.*\/\/=\s+require turbolinks.*$/, ''
    end

    inside 'stylesheets' do
      remove_file 'application.css'
      replace_file 'application.scss'
    end
  end

  inside 'views' do
    inside 'layouts' do
      replace_file 'application.html.erb'
      replace_file (install_devise ? '_header-devise.html.erb' : '_header.html.erb'), '_header.html.erb'
      replace_file '_footer.html.erb'
    end

    inside 'welcome' do
      replace_file 'index.html.erb'
    end
  end
end

git :init
git add: "."
git commit: %Q{ -m 'Initial commit' }
