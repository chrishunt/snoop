require 'snoop/http'
require 'support/http_server'

describe Snoop::Http do
  with_http_server do |url|
    it 'notifies when content has changed' do
      snoop = described_class.new(url: "#{url}/dynamic-content")

      notification_count = 0

      snoop.notify times: 2 do
        notification_count += 1
      end

      expect(notification_count).to eq 2
    end

    it 'does not notify when content has not changed' do
      snoop = described_class.new(url: "#{url}/static-content")

      notification_count = 0

      snoop.notify times: 2 do
        notification_count += 1
      end

      expect(notification_count).to eq 1
    end
  end
end
