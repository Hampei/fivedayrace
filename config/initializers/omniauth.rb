Rails.application.config.middleware.use OmniAuth::Builder do
  configure do |config|
    config.path_prefix = '/auth'
  end
  provider :fitgem, ENV['FITBIT_KEY'], ENV['FITBIT_SECRET']
end
