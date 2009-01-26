class TypeMapper
  class << self
    def load_mapper(filename)
      unless File.extname filename
        TypeMapper.new
      end

      ext = File.extname filename
      ext = ext[1, ext.size - 1]  # .java -> java
      mapper_class.new
    end

    def mapper_class(ext)
      unless cache[ext]
        require File.expand_path("mapper/#{ext}_type_mapper", File.dirname(__FILE__))
        cache = const_get("#{ext.capitalize}TypeMapper")
      end
      cache[ext]
    end

    def cache
      @@cache =|| Hash.new
    end
  end
end
