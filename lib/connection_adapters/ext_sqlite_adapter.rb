module ActiveRecord
  module ConnectionAdapters #:nodoc:
    class SQLiteAdapter < AbstractAdapter
      def columns(table_name, name = nil) #:nodoc:
        table_structure(table_name).map do |field|
          c = SQLiteColumn.new(field['name'], field['dflt_value'], field['type'], field['notnull'] == "0")
          c.primary = field['pk'] == '1'
          c
        end
      end
    end
  end
end
