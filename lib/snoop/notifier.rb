module Snoop
  # Generic notifier. Create subclasses for different protocols
  class Notifier
    UnimplementedException = Class.new(StandardError)

    attr_accessor :content

    DEFAULT_NOTIFY_OPTIONS = {
      delay: 0,
      count: 1,
      while: -> { false },
      until: -> { true }
    }

    def notify(options = {})
      options = DEFAULT_NOTIFY_OPTIONS.merge options

      while (
        (options[:count] -= 1) >= 0 ||
        options.fetch(:while).call  ||
        !options.fetch(:until).call
      )
        yield content if content_changed?
        sleep options.fetch(:delay)
      end
    end

    def content_changed?
      old_content = @content
      @content = fetch_content
      old_content != @content
    end

    def fetch_content
      raise UnimplementedException.new '#fetch_content must be implemented'
    end
  end
end
