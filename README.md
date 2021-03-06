# rails-templates

These are the standard templates I use to create new rails apps. They generally use the most recent versions of the gems involved, unless otherwise stated.

## Usage

To set up a basic application:

```
git clone git@github.com:timcheadle/rails-templates.git

# Make a new app
rails new APP_NAME -m rails-templates/app-template.rb --skip-spring --skip-test-unit
```

## Goodies

My templates use the following goodies in addition to the standard Rails install:

- PostgreSQL
- Rspec
- Capybara
- Pry
- Guard
- Redcarpet (for markdown)
    - Includes a `markdown()` view helper
- Hirb
- Seedbank
- Twitter Bootstrap (optional)
- Font Awesome
- Devise
