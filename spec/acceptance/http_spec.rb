require 'snoop/http'
require 'support/http_server'

describe Snoop::Http do
  with_http_server do |url|
    it 'notifies when content has changed' do
      snoop = described_class.new(url: "#{url}/dynamic-content")

      notification_count = 0

      snoop.notify count: 2 do
        notification_count += 1
      end

      expect(notification_count).to eq 2
    end

    it 'does not notify when content has not changed' do
      snoop = described_class.new(url: "#{url}/static-content")

      notification_count = 0

      snoop.notify count: 2 do
        notification_count += 1
      end

      expect(notification_count).to eq 1
    end

    it 'can target specific html elements' do
      snoop = described_class.new(url: "#{url}/html-content", css: 'p#message')

      html_content = nil

      snoop.notify do |content|
        html_content = content
      end

      expect(html_content).to eq 'Hello Rspec'
    end
  end
end
