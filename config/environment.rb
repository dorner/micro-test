# Load the Rails application.
require_relative 'application'

if File.exists?("#{Rails.root}/admin-shared/config/applications.rb")
  require "#{Rails.root}/admin-shared/config/applications.rb"
end

#TODO REMOVE THIS LINE WHEN YOU ACTUALLY HAVE YOUR APP IN THE MAIN LIST
Rails.configuration.application_list ||= {}
Rails.configuration.application_list['test_app'] = {
  'title': 'Test App',
  url: {
    development: 'http://localhost:3000'
  }
}

# Initialize the Rails application.
Rails.application.initialize!
