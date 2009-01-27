class TypeMapper
  class << self
    def load_mapper(filename)
      unless File.extname filename
        TypeMapper.new
      end

      ext = File.extname filename
      ext = ext[1, ext.size - 1]  # .java -> java
      mapper_class(ext).new
    end

    def mapper_class(ext)
      unless cache[ext]
        require File.expand_path("mapper/#{ext}_type_mapper", File.dirname(__FILE__))
        cache[ext] = const_get("#{ext.capitalize}TypeMapper")
      end
      cache[ext]
    end

    def cache
      @@cache ||= Hash.new
    end
  end

  def file_name(table, filename)
    name = table.table_name.capitalize
    basename = File.basename(filename)
    basename.sub(/_?[Tt]able_?/, name)
  end

  def class_name(table)
    table.table_name.capitalize
  end

  def type_name(column)
    send("type_#{column.type}")
  end

  def name(column)
    column.name
  end
end

