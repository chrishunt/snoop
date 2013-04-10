require 'web_notifier/monitor'

describe WebNotifier::Monitor do
  subject { described_class.new(url: url) }

  describe '#initialize' do
    context 'when url is provided' do
      let(:url) { 'http://example.com' }

      it 'saves the url' do
        expect(subject.url).to eq url
      end
    end

    context 'when a url is not provided' do
      let(:url) { nil }

      it 'raises an exception' do
        expect {
          subject
        }.to raise_error WebNotifier::Monitor::UrlRequiredException
      end
    end
  end
end
