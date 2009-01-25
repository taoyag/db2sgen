class AdapterLoader
  def self.load(config)
    begin
      require File.expand_path("ext_#{config['adapter']}_adapter", File.dirname(__FILE__))
    rescue
      raise "failed to load ext_#{config['adapter']}_adapter"
    end
  end
end
