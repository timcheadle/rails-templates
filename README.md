# rails-templates

These are the standard templates I use to create new rails apps. They generally use the most recent versions of the gems involved, unless otherwise stated.

## Usage

To set up a basic application with Devise:

```
rails new YOUR_APP_NAME_HERE -m https://raw.githubusercontent.com/timcheadle/rails-templates/master/rails_app.rb
```

## Goodies

My templates use the following goodies in addition to the standard Rails install:

- PostgreSQL
- Devise
- Rspec 
- Capybara
- Pry
- Guard
- Redcarpet (for markdown)
    - Includes a `markdown()` view helper
- Twitter Bootstrap (optional)
- Font Awesome	
