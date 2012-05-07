# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

app = Rack::Builder.new do
  use Rack::CommonLogger

  map '/fitbit' do
    run ::FitbitCallbackHandler
  end

  map '/' do
    run Hundredourrace::Application
  end
end.to_app

run app
