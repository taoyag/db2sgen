require 'rubygems'
require 'activesupport'

class TypeMapper
  class << self
    def load_mapper(filename)
      if File.extname(filename) == ""
        return TypeMapper.new
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
    dirname  = File.dirname(filename)
    basename = File.basename(filename)

    name = nil
    case basename
    when /table/
      name = basename.sub(/table/, table.table_name.camelize(:lower))
    when /Table/
      name = basename.sub(/Table/, table.table_name.camelize)
    end
    File.join dirname, name
  end

  def class_name(table)
    table.table_name.camelize
  end

  def type_name(column)
    send("type_#{column.type}")
  end

  def name(column)
    column.name
  end

  def method_missing(name, &args)
    if /^type_(.+)$/ =~ name.to_s
      $1
    else
      super
    end
  end
end

