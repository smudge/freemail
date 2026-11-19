require 'fileutils'
require 'open3'
require 'tmpdir'

RSpec.describe 'patch version bump' do
  def with_version(source)
    Dir.mktmpdir do |dir|
      FileUtils.mkdir_p File.join(dir, 'bin')
      FileUtils.mkdir_p File.join(dir, 'lib/freemail')
      FileUtils.cp File.expand_path('../bin/bump-patch', __dir__), File.join(dir, 'bin/bump-patch')
      path = File.join(dir, 'lib/freemail/version.rb')
      File.write(path, source)
      yield dir, path
    end
  end

  it 'increments the patch number' do
    source = "module Freemail\n  VERSION = '0.10.9'\nend\n"
    with_version(source) do |dir, path|
      _out, err, status = Open3.capture3('ruby', 'bin/bump-patch', chdir: dir)
      expect(status.success?).to be(true), err
      expect(File.read(path)).to eq(source.sub('0.10.9', '0.10.10'))
    end
  end

  it 'fails if the version cannot be parsed' do
    with_version("module Freemail\nend\n") do |dir, path|
      _out, _err, status = Open3.capture3('ruby', 'bin/bump-patch', chdir: dir)
      expect(status.success?).to be(false)
      expect(File.read(path)).to eq("module Freemail\nend\n")
    end
  end
end
