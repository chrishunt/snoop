require 'httparty'
require 'nokogiri'

module Snoop
  class Http
    UrlRequiredException = Class.new(StandardError)

    attr_reader :url, :css, :http_client
    attr_accessor :content

    def initialize(url: nil, css: nil, http_client: HTTParty)
      raise UrlRequiredException if url.nil?

      @url = url
      @css = css
      @http_client = http_client
    end

    def notify(
      delay: 0, count: 1, while_true: -> { false }, while_false: -> { true }
    )
      while (count -= 1) >= 0 || while_true.call || !while_false.call
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
      content = http_client.get(url).body

      if css
        content = Nokogiri::HTML(content).css(css).map(&:text).join
      end

      content
    end
  end
end
