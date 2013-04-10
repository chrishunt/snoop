require 'httparty'
require 'sinatra/base'

module Snoop
  class HttpServer < Sinatra::Base
    set :port, 8001

    get '/' do
      'success'
    end

    get '/dynamic-content' do
      @@count ||= 0
      @@count += 1
      @@count.to_s
    end

    get '/static-content' do
      'same ol stuff'
    end
  end
end

def with_http_server
  url = "http://localhost:#{Snoop::HttpServer.port}"
  server_thread = Thread.new { Snoop::HttpServer.run! }

  while true
    begin
      HTTParty.get(url)
      break
    rescue Errno::ECONNREFUSED
      sleep 0.5
    end
  end

  yield(url)
end
