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
    attr_accessor :xml_url, :xml_user, :xml_pass, :home_lat, :home_long, :max_distance

    def initialize
      @xml_user     = ""
      @xml_pass     = ""
      @xml_url      = "https://data.cotrip.org/xml/cameras.xml"
      @home_lat     = 0
      @home_long    = 0
      @max_distance = 242000 # Distance in meters to grab cameras
    end
  end
end
