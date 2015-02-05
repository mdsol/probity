require 'probity/version'
require 'probity/middleware'

module Probity
  def self.validators
    @validators ||= {}
  end
end

unless ENV['PROBITY_NO_AUTOLOAD']
  Gem.find_files('probity/validators/*.rb').each { |f| require(f) }
end
