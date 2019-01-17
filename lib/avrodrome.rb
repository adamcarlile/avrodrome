require "ostruct"
require "logger"

require "avrodrome/version"

require "avrodrome/schema"
require "avrodrome/subject"
require "avrodrome/registry"
require "avrodrome/adaptor"


module Avrodrome
  module_function

  def version
    Avrodrome::VERSION
  end

  def config
    @config ||= OpenStruct.new.tap do |c|
      c.logger = Logger.new(STDOUT)
    end
  end

  def configure(&block)
    yield(config)
  end

  def logger
    config.logger
  end

end
