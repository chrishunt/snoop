require 'httparty'
require 'nokogiri'

module Snoop
  class Http
    UrlRequiredException = Class.new(StandardError)

    DEFAULT_OPTIONS = {
      delay: 0,
      count: 1,
      while: -> { false },
      until: -> { true }
    }

    attr_reader :url, :css, :http_client
    attr_accessor :content

    def initialize(url: nil, css: nil, http_client: HTTParty)
      raise UrlRequiredException if url.nil?

      @url = url
      @css = css
      @http_client = http_client
    end

    def notify(options = {})
      options = DEFAULT_OPTIONS.merge(options)

      while (
        (options[:count] -= 1 ) >= 0 ||
        options[:while].call         ||
        !options[:until].call
      )
        yield content if content_changed?
        sleep options[:delay]
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
