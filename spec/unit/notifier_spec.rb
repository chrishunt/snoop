require 'spec_helper'
require 'snoop/notifier'

describe Snoop::Notifier do
  describe '#fetch_content' do
    it 'raises an exception for unimplemented required methods' do
      expect {
        subject.fetch_content
      }.to raise_error Snoop::Notifier::UnimplementedException
    end
  end

  describe '#notify' do
    let(:content) { 'abc123' }
    let(:content_changed?) { true }

    before do
      allow(subject).to receive_messages(
        content: content,
        content_changed?: content_changed?
      )
    end

    it 'notifies the requested number of times' do
      notification_count = 0

      subject.notify count: 5 do
        notification_count += 1
      end

      expect(notification_count).to eq 5
    end

    it 'notifies while an expression is true' do
      notification_count = 0

      subject.notify while: -> { notification_count < 3 }  do
        notification_count += 1
      end

      expect(notification_count).to eq 3
    end

    it 'notifies until an expression is true' do
      notification_count = 0

      subject.notify until: -> { notification_count > 2 }  do
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

        expect(yielded).to be false
      end
    end
  end

  describe '#content_changed?' do
    it 'updates the content' do
      subject.content = 'abc123'
      allow(subject).to receive_messages(fetch_content: 'def456')

      subject.content_changed?

      expect(subject.content).to eq 'def456'
    end

    context 'when content has changed' do
      before do
        subject.content = 'abc123'
        allow(subject).to receive_messages(fetch_content: 'def456')
      end

      it 'returns true' do
        expect(subject.content_changed?).to be true
      end
    end

    context 'when content has not changed' do
      before do
        subject.content = 'abc123'
        allow(subject).to receive_messages(fetch_content: 'abc123')
      end

      it 'returns false' do
        expect(subject.content_changed?).to be false
      end
    end
  end
end
