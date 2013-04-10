require 'snoop/http_monitor'

describe Snoop::HttpMonitor do
  subject { described_class.new(url: url) }

  let(:url) { 'http://example.com' }

  describe '#initialize' do
    it 'saves the url' do
      expect(subject.url).to eq url
    end

    context 'when a url is not provided' do
      let(:url) { nil }

      it 'raises an exception' do
        expect {
          subject
        }.to raise_error Snoop::HttpMonitor::UrlRequiredException
      end
    end
  end

  describe '#notify' do
    let(:notifier) { stub }

    before do
      subject.stub(
        content_changed?: content_changed?,
        notifier: notifier
      )
    end

    context 'when the content changes' do
      let(:content_changed?) { true }

      it 'triggers a notification' do
        notifier.should_receive(:notify)
        subject.notify
      end
    end

    context 'when the content does not change' do
      let(:content_changed?) { false }

      it 'does not trigger a notification' do
        notifier.should_not_receive(:notify)
        subject.notify
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
    it 'fetches content over http' do
      response = stub('HttpResponse', body: 'stuff')
      http_client = stub('HttpClient')

      subject.stub(http_client: http_client)

      http_client.should_receive(:get).with(url).and_return(response)

      expect(subject.fetch_content).to eq response.body
    end
  end
end
