DEBUG = true
require 'rubygems'
require 'activerecord'
require 'erb'
require 'fileutils'

require File.expand_path('definitions', File.dirname(__FILE__))
require File.expand_path('ext_activerecord', File.dirname(__FILE__))
require File.expand_path('connection_adapters/ext_adapter', File.dirname(__FILE__))

class SourceGenerator
  attr_accessor :config, :template_dir, :out_dir

  def initialize(config)
    @config = config
  end

  def generate
    setup
    collect_tables
    output
  end

  def setup
    ActiveRecord::Base.establish_connection config['database']
    AdapterLoader.load config['database']

    @template_dir = config['template_dir']
    @out_dir      = config['out_dir']
  end

  def collect_tables
    @tables = TableDefinition.collect config['tables']
    if DEBUG
      @tables.each do |t|
        puts "-- #{t.table_name}"
        t.columns.each do |c|
          puts " #{c.name} #{c.type} #{c.precision} #{'primary key' if c.primary}"
        end
      end
    end
  end

  def output
    template_files do |f|
      @tables.each do |table|
        out table, f
      end
    end
  end

  def template_files
    files = []
    Dir.glob("#{@template_dir}/**/*") do |f|
      next unless File.file? f
      file = f.sub("#{@template_dir}/", '')
      yield(file) if block_given?
      files << file
    end
    files
  end

  def out(table, template)
    #TODO mapper, filename
    erb = ERB.new(File.read(File.expand_path(template, @template_dir)))
    r_file = File.expand_path(template, @out_dir)
    puts r_file
    FileUtils.mkdir_p(File.dirname(r_file)) unless FileTest.exist?(File.dirname(r_file))
    File.open(r_file, "w") do |f|
      f.write erb.result(binding)
    end
  end
end
