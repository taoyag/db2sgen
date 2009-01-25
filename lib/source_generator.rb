DEBUG = true
require 'rubygems'
require 'activerecord'

require File.expand_path('definitions', File.dirname(__FILE__))
require File.expand_path('ext_activerecord', File.dirname(__FILE__))
require File.expand_path('connection_adapters/ext_adapter', File.dirname(__FILE__))

class SourceGenerator
  attr_accessor :config

  def initialize(config)
    @config = config
  end

  def generate
    setup
    collect_tables
  end

  def setup
    ActiveRecord::Base.establish_connection config['database']
    AdapterLoader.load config['database']
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
end
