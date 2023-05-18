require 'freemail/version'

module Freemail
  ROOT = File.join(File.dirname(File.expand_path(__FILE__)), '../')
  DISPOSABLE = Hash[File.readlines("#{ROOT}/data/disposable.txt").map { |d| [d.strip.downcase] }]
  FREE = Hash[File.readlines("#{ROOT}/data/free.txt").map { |d| [d.strip.downcase] }]

  def self.add_disposable_domains(custom_domains)
    custom_domains = [custom_domains] unless custom_domains.is_a? Array
    custom_domains.each { |domain| DISPOSABLE[domain] = nil }
  end

  def self.add_free_domains(custom_domains)
    custom_domains = [custom_domains] unless custom_domains.is_a? Array
    custom_domains.each { |domain| FREE[domain] = nil }
  end

  def self.free?(email)
    FREE.key?(get_domain(email))
  end

  def self.disposable?(email)
    DISPOSABLE.key?(get_domain(email))
  end

  def self.free_or_disposable?(email)
    free?(email) || disposable?(email)
  end

  def self.get_domain(email)
    email.split('@')[1..-1]&.join('@')&.downcase&.strip
  end
end
