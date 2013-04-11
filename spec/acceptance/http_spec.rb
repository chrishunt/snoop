require 'snoop/http'
require 'support/http_server'

describe Snoop::Http do
  class TestNotifier
    attr_reader :notification_count

    def initialize(notification_count = 0)
      @notification_count = notification_count
    end

    def notify
      @notification_count += 1
    end
  end

  let(:notifier) { TestNotifier.new }

  with_http_server do |url|
    it 'notifies when http content has changed' do
      monitor = described_class.new(
        url: "#{url}/dynamic-content",
        notifier: notifier
      )

      2.times { monitor.notify }
      expect(notifier.notification_count).to eq 2
    end

    it 'does not notify when http content has not changed' do
      monitor = described_class.new(
        url: "#{url}/static-content",
        notifier: notifier
      )

      2.times { monitor.notify }
      expect(notifier.notification_count).to eq 1
    end
  end
end
