# in application.rb add
# config.middleware.use "RedirectFromWww"
# though might need  to be added earlier in the stack to beat the ssl redirect.
class RedirectFromWww
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    if request.host.starts_with?("www.")
      [301, {"Location" => request.url.sub("//www.", "//")}, []]
    else
      @app.call(env)
    end
  end
end
