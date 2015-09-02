require 'freemail/version'

module Freemail
  DISPOSABLE = Hash[File.readlines('data/disposable.txt').map { |d| [d.strip.downcase] }]
  FREE = Hash[File.readlines('data/free.txt').map { |d| [d.strip.downcase] }]

  def self.free?(email)
    FREE.key?(get_domain(email))
  end

  def self.disposable?(email)
    DISPOSABLE.key?(get_domain(email))
  end

  def self.get_domain(email)
    email.split('@').last.downcase.strip
  end
end
