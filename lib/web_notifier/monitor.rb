module WebNotifier
  class Monitor
    UrlRequiredException = Class.new(StandardError)

    attr_reader :url

    def initialize(url: nil)
      raise UrlRequiredException if url.nil?
      @url = url
    end
  end
end
