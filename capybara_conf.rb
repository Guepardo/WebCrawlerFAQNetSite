# Require the gems
require 'capybara/poltergeist'

# Configure Poltergeist to not blow up on websites with js errors aka every website with js
# See more options at https://github.com/teampoltergeist/poltergeist#customization

Capybara.javascript_driver = :poltergeist

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false, phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes'],  timeout: 180)
end

# Configure Capybara to use Poltergeist as the driver
Capybara.default_driver = :poltergeist
	