require_relative 'boot'


require 'rails/all'


require 'sprockets/es6'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TestApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths << "#{Rails.root}/job_controller"
    config.eager_load_paths << "#{Rails.root}/job_controller"
    config.autoload_paths << "#{Rails.root}/admin-shared/mixins"
    config.eager_load_paths << "#{Rails.root}/admin-shared/mixins"
    config.autoload_paths << "#{Rails.root}/users"
    config.eager_load_paths << "#{Rails.root}/users"
    config.active_job.queue_adapter = :active_elastic_job
    config.time_zone = 'Eastern Time (US & Canada)'
  end
end

ENV['APP_NAME_CLEAN'] = 'test_app'
