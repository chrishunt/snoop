require 'httparty'

module WebNotifier
  class HttpMonitor
    UrlRequiredException = Class.new(StandardError)

    attr_reader :url, :notifier, :content, :http_client
    attr_accessor :content

    def initialize(
      url: nil, http_client: HTTParty, notifier: MacOSNotifier.new
    )
      raise UrlRequiredException if url.nil?
      @url = url
      @http_client = http_client
      @notifier = notifier
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
