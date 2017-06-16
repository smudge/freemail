require 'freemail/version'

module Freemail
  ROOT = File.join(File.dirname(File.expand_path(__FILE__)), '../')
  DISPOSABLE = File.readlines("#{ROOT}/data/disposable.txt").map { |d| d.strip.downcase }
  FREE = File.readlines("#{ROOT}/data/free.txt").map { |d| d.strip.downcase }

  def self.free?(email)
    FREE.include?(get_domain(email))
  end

  def self.disposable?(email)
    DISPOSABLE.include?(get_domain(email))
  end

  def self.free_or_disposable?(email)
    free?(email) || disposable?(email)
  end

  def self.get_domain(email)
    email.split('@').last.downcase.strip
  end
end
