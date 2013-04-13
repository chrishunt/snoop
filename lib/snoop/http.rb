require 'httparty'
require 'nokogiri'

module Snoop
  class Http < Notifier
    UrlRequiredException = Class.new(StandardError)

    DEFAULT_INIT_OPTIONS = {
      url: nil,
      css: nil,
      http_client: HTTParty
    }

    attr_reader :url, :css, :http_client

    def initialize(options = {})
      options = DEFAULT_INIT_OPTIONS.merge options

      raise UrlRequiredException if options.fetch(:url).nil?

      @url         = options.fetch :url
      @css         = options.fetch :css
      @http_client = options.fetch :http_client
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
