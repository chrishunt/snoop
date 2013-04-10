require 'httparty'

module Snoop
  class HttpMonitor
    UrlRequiredException = Class.new(StandardError)

    attr_reader :url, :notifier, :content, :http_client, :interval
    attr_accessor :content

    def initialize(
      url: nil, http_client: HTTParty, notifier: MacOSNotifier.new, interval: 1
    )
      raise UrlRequiredException if url.nil?
      @url = url
      @http_client = http_client
      @notifier = notifier
      @interval = interval
    end

    def monitor
      while true
        notify
        sleep interval
      end
    end

    def notify
      notifier.notify if content_changed?
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

  class MacOSNotifier
  end
end
