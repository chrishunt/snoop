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

  describe '#notify' do
    let(:content) { 'abc123' }
    let(:content_changed?) { true }

    before do
      subject.stub(
        content: content,
        content_changed?: content_changed?
      )
    end

    it 'notifies the requested number of times' do
      notification_count = 0

      subject.notify times: 5 do
        notification_count += 1
      end

      expect(notification_count).to eq 5
    end

    it 'notifies while an expression is true' do
      notification_count = 0

      subject.notify while_true: -> { notification_count < 3 }  do
        notification_count += 1
      end

      expect(notification_count).to eq 3
    end

    it 'notifies while an expression is false' do
      notification_count = 0

      subject.notify while_false: -> { notification_count > 2 }  do
        notification_count += 1
      end

      expect(notification_count).to eq 3
    end

    it 'yields the content to the notification block' do
      yielded_content = nil

      subject.notify { |content| yielded_content = content }

      expect(yielded_content).to eq content
    end

    context 'when the content does not change' do
      let(:content_changed?) { false }

      it 'does not yield the notification block' do
        yielded = false

        subject.notify { yielded = true }

        expect(yielded).to be_false
      end
    end
  end

  describe '#content_changed?' do
    it 'updates the content' do
      subject.content = 'abc123'
      subject.stub(fetch_content: 'def456')

      subject.content_changed?

      expect(subject.content).to eq 'def456'
    end

    context 'when content has changed' do
      before do
        subject.content = 'abc123'
        subject.stub(fetch_content: 'def456')
      end

      it 'returns true' do
        expect(subject.content_changed?).to be_true
      end
    end

    context 'when content has not changed' do
      before do
        subject.content = 'abc123'
        subject.stub(fetch_content: 'abc123')
      end

      it 'returns false' do
        expect(subject.content_changed?).to be_false
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
