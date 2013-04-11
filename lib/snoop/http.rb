require 'httparty'

module Snoop
  class Http
    UrlRequiredException = Class.new(StandardError)

    attr_reader :url, :http_client, :interval, :content
    attr_accessor :content

    def initialize(url: nil, http_client: HTTParty)
      raise UrlRequiredException if url.nil?
      @url = url
      @http_client = http_client
    end

    def notify(delay: 0, times: 1, while_true: -> { false })
      while (times -= 1) >= 0 || while_true.call
        yield content if content_changed?
        sleep delay
      end
    end

    def content_changed?
      old_content = @content
      @content = fetch_content
      old_content != @content
    end

    def fetch_content
      http_client.get(url).body
    end
  end
end
