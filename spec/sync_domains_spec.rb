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
      File.write(File.join(@data, 'disposable.txt'), "old-disposable.test\nnospammail.net\nblocked.test\n")
      File.write(File.join(@data, 'free.txt'), "free.test\nold-disposable.test\nscientist.com\n")
      File.write(File.join(@data, 'blocklist.txt'), "blocked.test\nnospammail.net\nscientist.com\n")
      File.write(File.join(@data, 'addlist.txt'), "manual.test\n")

      mock_bin = File.join(root, 'mock-bin')
      FileUtils.mkdir_p mock_bin
      File.write(File.join(mock_bin, 'curl'), <<~SH)
        #!/bin/sh
        for url do :; done
        case "$url" in
          *tompec/disposable-email-domains/*)
            [ "$FAIL_SOURCE" = disposable ] && exit 22
            if [ "$FAIL_SOURCE" = invalid ]; then
              printf '%s\n' '{"domains":[]}'
            else
              printf '%s\n' '["new-disposable.test", "blocked.test", "free.test"]'
            fi ;;
          *willwhite/freemail/*)
            [ "$FAIL_SOURCE" = free ] && exit 22
            printf '%s\n' ' New-Free.TEST ' 'scientist.com' 'old-disposable.test' ;;
          *) exit 22 ;;
        esac
      SH
      FileUtils.chmod 0755, File.join(mock_bin, 'curl')
      @env = { 'PATH' => "#{mock_bin}:#{ENV.fetch('PATH')}", 'FAIL_SOURCE' => '' }
      example.run
    end
  end

  def sync
    Open3.capture3(@env, 'bash', 'bin/sync-domains', chdir: @root)
  end

  def domains(name)
    File.readlines(File.join(@data, "#{name}.txt"), chomp: true)
  end

  it 'merges sources without reintroducing blocked domains' do
    2.times do
      _out, err, status = sync
      expect(status.success?).to be(true), err
      expect(domains('disposable')).to eq(%w[free.test manual.test new-disposable.test old-disposable.test])
      expect(domains('addlist')).to eq(%w[manual.test old-disposable.test])
      expect(domains('free')).to eq(%w[new-free.test])
    end
  end

  %w[disposable free invalid].each do |failure|
    it "preserves data when #{failure} source fails" do
      @env['FAIL_SOURCE'] = failure
      before = %w[free disposable addlist].to_h { |name| [name, domains(name)] }
      _out, _err, status = sync
      expect(status.success?).to be(false)
      expect(domains('free')).to eq(before.fetch('free'))
      expect(domains('disposable')).to eq(before.fetch('disposable'))
      expect(domains('addlist')).to eq(before.fetch('addlist'))
    end
  end
end
