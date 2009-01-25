require 'rubygems'
require 'activerecord'

class TableDefinition
  attr_accessor :table_name, :columns

  def self.generate(table_name)
    class_name = "A#{table_name}"
    eval %-
    class #{class_name} < ActiveRecord::Base
      set_table_name '#{table_name}'
    end
    -

    table = const_get(class_name)
    TableDefinition.new(table_name, table.columns)
  end

  def initialize(table_name, columns)
    @table_name = table_name
    @columns = columns
  end
end
