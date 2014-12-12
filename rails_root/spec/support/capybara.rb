require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'

module RequestMacros
  def select_by_id(id, options = {})
    field = options[:from]
    option_xpath = "//*[@id='#{field}']/option[#{id}]"
    option_text = find(:xpath, option_xpath).text
    select option_text, :from => field
  end

  def select_date(date, options = {})
    field = options[:from]
    select date.year.to_s,   :from => "#{field}_1i"
    select_by_id date.month, :from => "#{field}_2i"
    select date.day.to_s,    :from => "#{field}_3i"
  end
end

RSpec.configure do |config|
  config.include Capybara::DSL
  #config.include Rails.application.routes.url_helpers
  config.include RequestMacros, type: :request
  Capybara.javascript_driver = :poltergeist
end
