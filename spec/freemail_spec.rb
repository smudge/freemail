require 'spec_helper'

describe Freemail do
  it 'has a version number' do
    expect(Freemail::VERSION).not_to be nil
  end

  describe '.free?' do
    subject { Freemail.free?(email) }

    context 'with a free email' do
      let(:email) { 'gopackers@gmail.com' }
      it { is_expected.to be(true) }
    end

    context 'with a disposable email' do
      let(:email) { 'metroidfan9000@10minutemail.com' }
      it { is_expected.to be(false) }
    end

    context 'with a paid/private email' do
      let(:email) { 'steve@apple.com' }
      it { is_expected.to be(false) }
    end
  end

  describe '.disposable?' do
    subject { Freemail.disposable?(email) }

    context 'with a free email' do
      let(:email) { 'gopackers@gmail.com' }
      it { is_expected.to be(false) }
    end

    context 'with a disposable email' do
      let(:email) { 'metroidfan9000@10minutemail.com' }
      it { is_expected.to be(true) }
    end

    context 'with a paid/private email' do
      let(:email) { 'steve@apple.com' }
      it { is_expected.to be(false) }
    end
  end
end
