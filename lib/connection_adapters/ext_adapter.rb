class AdapterLoader
  def initialize(config)
    @config = config
  end

  def load
    begin
      require File.expand_path("ext_#{@config['adapter']}_adapter", File.dirname(__FILE__))
    rescue
      raise "failed to load ext_#{@config['adapter']}_adapter"
    end
  end
end
