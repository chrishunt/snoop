require 'snoop/http'
require 'support/http_server'

describe Snoop::Http do
  with_http_server do |url|
    it 'notifies on change event' do
      snoop = described_class.new(url: "#{url}/dynamic-content")

      notification_count = 0
      snoop.notify(delay: 0, times: 2) { notification_count += 1 }

      expect(notification_count).to eq 2
    end

    it 'does not notify when http content has not changed' do
      snoop = described_class.new(url: "#{url}/static-content")

      notification_count = 0
      snoop.notify(delay: 0, times: 2) { notification_count += 1 }

      expect(notification_count).to eq 1
    end
  end
end
