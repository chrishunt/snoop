require 'httparty'
require 'nokogiri'

module Snoop
  class Http
    UrlRequiredException = Class.new(StandardError)

    DEFAULT_INIT_OPTIONS = {
      url: nil,
      css: nil,
      http_client: HTTParty
    }

    DEFAULT_NOTIFY_OPTIONS = {
      delay: 0,
      count: 1,
      while: -> { false },
      until: -> { true }
    }

    attr_reader :url, :css, :http_client
    attr_accessor :content

    def initialize(options = {})
      options = DEFAULT_INIT_OPTIONS.merge options

      raise UrlRequiredException if options.fetch(:url).nil?

      @url         = options.fetch :url
      @css         = options.fetch :css
      @http_client = options.fetch :http_client
    end

    def notify(options = {})
      options = DEFAULT_NOTIFY_OPTIONS.merge options

      while (
        (options[:count] -= 1) >= 0 ||
        options.fetch(:while).call  ||
        !options.fetch(:until).call
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
