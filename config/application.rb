require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RpcFileSystem
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.autoload_paths += [
      # this will allow the auto module searching of files like services/base.rb
      # without this, Services::Base cannot be resolved
      Rails.root.join('app').to_s,
      Rails.root.join('lib').to_s
    ]

    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'secrets.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end

    config.filter_parameters += [:file]
  end
end
