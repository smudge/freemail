require 'fileutils'
require 'open3'
require 'tmpdir'

RSpec.describe 'domain synchronization' do
  around do |example|
    Dir.mktmpdir do |root|
      @root = root
      FileUtils.mkdir_p File.join(root, 'bin')
      FileUtils.mkdir_p File.join(root, 'data')
      FileUtils.cp File.expand_path('../bin/sync-domains', __dir__), File.join(root, 'bin/sync-domains')

      @data = File.join(root, 'data')
      File.write(File.join(@data, 'disposable.txt'), "old-disposable.test\nblocked.test\n")
      File.write(File.join(@data, 'free.txt'), "free.test\nold-disposable.test\n")
      File.write(File.join(@data, 'blocklist.txt'), "blocked.test\n")
      File.write(File.join(@data, 'sources.txt'), "https://test.invalid/free\n")

      mock_bin = File.join(root, 'mock-bin')
      FileUtils.mkdir_p mock_bin
      File.write(File.join(mock_bin, 'curl'), <<~SH)
        #!/bin/sh
        for url do :; done
        case "$url" in
          *ivolo/disposable-email-domains*)
            printf '%s\n' '["new-disposable.test", "blocked.test", "free.test"]' ;;
          https://test.invalid/free)
            printf '%s\n' ' New-Free.TEST ' 'blocked.test' 'old-disposable.test' ;;
          *) exit 22 ;;
        esac
      SH
      FileUtils.chmod 0755, File.join(mock_bin, 'curl')
      @env = { 'PATH' => "#{mock_bin}:#{ENV.fetch('PATH')}" }
      example.run
    end
  end

  def sync
    Open3.capture3(@env, 'bash', 'bin/sync-domains', chdir: @root)
  end

  def domains(name)
    File.readlines(File.join(@data, "#{name}.txt"), chomp: true)
  end

  it 'merges sources, retains existing entries and excludes blocked domains' do
    _out, err, status = sync
    expect(status.success?).to be(true), err
    expect(domains('disposable')).to eq(%w[free.test new-disposable.test old-disposable.test])
    expect(domains('free')).to eq(%w[new-free.test])

    _out, err, status = sync
    expect(status.success?).to be(true), err
    expect(domains('disposable')).to eq(%w[free.test new-disposable.test old-disposable.test])
    expect(domains('free')).to eq(%w[new-free.test])
  end

  it 'does not replace data when all free-domain sources fail' do
    File.write(File.join(@data, 'sources.txt'), "https://test.invalid/fail\n")
    before = %w[free disposable].to_h { |name| [name, domains(name)] }
    _out, _err, status = sync
    expect(status.success?).to be(false)
    expect(domains('free')).to eq(before.fetch('free'))
    expect(domains('disposable')).to eq(before.fetch('disposable'))
  end
end
