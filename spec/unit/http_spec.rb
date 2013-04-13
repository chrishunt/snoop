require 'spec_helper'
require 'snoop/notifier'
require 'snoop/http'

describe Snoop::Http do
  subject { described_class.new(url: url, css: css) }

  let(:url) { 'http://example.com' }
  let(:css) { nil }

  describe '#initialize' do
    it 'saves the url' do
      expect(subject.url).to eq url
    end

    context 'when a url is not provided' do
      let(:url) { nil }

      it 'raises an exception' do
        expect {
          subject
        }.to raise_error Snoop::Http::UrlRequiredException
      end
    end

    context 'when a css matches is provided' do
      let(:css) { 'p#awesome' }

      it 'saves the css matcher' do
        expect(subject.css).to eq css
      end
    end
  end

  describe '#fetch_content' do
    before do
      response = stub('HttpResponse', body: body)

      http_client = stub('HttpClient')
      http_client.should_receive(:get).with(url).and_return(response)

      subject.stub(http_client: http_client)
    end

    let(:body) { 'Awesome HTML' }

    it 'fetches content over http' do
      expect(subject.fetch_content).to eq body
    end

    context 'when a css selector is provided' do
      let(:body) {<<-HTML
        <html>
          <body>
            This is some annoying text we don't want to see.
            <p id='message'>#{content}</p>
          </body>
        </html>
      HTML
      }

      let(:css) { 'p#message' }
      let(:content) { 'Hello RSpec!' }

      it 'only fetches matching content' do
        expect(subject.fetch_content).to eq content
      end
    end
  end
end
