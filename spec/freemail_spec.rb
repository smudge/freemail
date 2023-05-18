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

    context 'with a user-name-only email' do
      let(:email) { 'gmail.com@' }
      it { is_expected.to be(false) }
    end

    context 'with a domain-only email' do
      let(:email) { '@gmail.com' }
      it { is_expected.to be(true) }
    end

    context 'with an @-only email' do
      let(:email) { '@' }
      it { is_expected.to be(false) }
    end

    context 'with an empty string' do
      let(:email) { '' }
      it { is_expected.to be(false) }
    end

    context 'with a double-@ email' do
      let(:email) { 'gopackers@@gmail.com' }
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

    context 'with a user-name-only email' do
      let(:email) { '10minutemail.com@' }
      it { is_expected.to be(false) }
    end

    context 'with a domain-only email' do
      let(:email) { '@10minutemail.com' }
      it { is_expected.to be(true) }
    end

    context 'with a double-@ email' do
      let(:email) { 'gopackers@@10minutemail.com' }
      it { is_expected.to be(false) }
    end
  end

  describe '.free_or_disposable?' do
    subject { Freemail.free_or_disposable?(email) }

    context 'with a free email' do
      let(:email) { 'gopackers@gmail.com' }
      it { is_expected.to be(true) }
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

  describe '.add_free_domains' do
    let!(:domain) { 'apple.com' }
    let(:email) { "steve@#{domain}" }
    subject { Freemail.free?(email) }

    context 'without additional domains.' do
      it { is_expected.to be(false) }
    end

    context 'with an additional domain.' do
      before { Freemail.add_free_domains(domain) }
      it { is_expected.to be(true) }
    end

    context 'with a list of additional domains' do
      before { Freemail.add_free_domains([domain]) }
      it { is_expected.to be(true) }
    end
  end

  describe '.add_disposable_domains' do
    let!(:domain) { 'apple.com' }
    let(:email) { "steve@#{domain}" }
    subject { Freemail.disposable?(email) }

    context 'without additional domains.' do
      it { is_expected.to be(false) }
    end

    context 'with an additional domain.' do
      before { Freemail.add_disposable_domains(domain) }
      it { is_expected.to be(true) }
    end

    context 'with a list of additional domains' do
      before { Freemail.add_disposable_domains([domain]) }
      it { is_expected.to be(true) }
    end
  end
end
