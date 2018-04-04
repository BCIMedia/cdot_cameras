require "cdot_camera/engine"

module CdotCamera
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :xml_url, :xml_user, :xml_pass

    def initialize
      @xml_user = ""
      @xml_pass = ""
      @xml_url  = "https://data.cotrip.org/xml/cameras.xml"
    end
  end
end
