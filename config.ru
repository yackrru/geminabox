require "rubygems"
require "geminabox"

Geminabox.data = "/var/geminabox-data" # ... or wherever

# Use Rack::Protection to prevent XSS and CSRF vulnerability if your geminabox server is open public.
# # Rack::Protection requires a session middleware, choose your favorite one such as Rack::Session::Memcache.
# # This example uses Rack::Session::Pool for simplicity, but please note that:
# # 1) Rack::Session::Pool is not available for multiprocess servers such as unicorn
# # 2) Rack::Session::Pool causes memory leak (it does not expire stored `@pool` hash)
use Rack::Session::Pool, expire_after: 1000 # sec
use Rack::Protection

# Basic Authentication
@@username = ENV["BASIC_USER"]
@@password = ENV["BASIC_PASS"]

unless @@username.empty? && @@password.empty?
  Geminabox::Server.helpers do
    def protected!
      unless authorized?
        response['WWW-Authenticate'] = %(Basic realm="Geminabox")
        halt 401, "No pushing or deleting without auth.\n"
      end
    end

    def authorized?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [@@username, @@password]
    end
  end

  Geminabox::Server.before '/upload' do
    protected!
  end

  Geminabox::Server.before do
    protected! if request.delete?
  end

  Geminabox::Server.before '/api/v1/gems' do
    unless env['HTTP_AUTHORIZATION'] == 'API_KEY'
      halt 401, "Access Denied. Api_key invalid or missing.\n"
    end
  end
end

run Geminabox::Server
