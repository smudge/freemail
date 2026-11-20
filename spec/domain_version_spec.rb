require 'spec_helper'
require 'set'
require_relative '../bin/bump-domain-version'

describe DomainVersion do
  def domains(count)
    Set.new((1..count).map { |i| "disposable:domain#{i}.example" })
  end

  it 'does not bump when domains do not change' do
    expect(described_class.bump_type(domains(100), domains(100))).to be_nil
  end

  it 'bumps patch below two percent' do
    expect(described_class.bump_type(domains(100), domains(100).merge(['disposable:new.example']))).to eq(:patch)
  end

  it 'bumps minor at two percent' do
    expect(described_class.bump_type(domains(100), domains(100).merge((1..2).map { |i| "disposable:new#{i}.example" }))).to eq(:minor)
  end

  it 'counts removals and reclassifications' do
    original = domains(100)
    changed = original - ['disposable:domain1.example']
    changed.add('free:domain1.example')
    changed.merge((1..0).map { |i| "disposable:new#{i}.example" })
    expect(described_class.bump_type(original, changed)).to eq(:minor)
  end
end
