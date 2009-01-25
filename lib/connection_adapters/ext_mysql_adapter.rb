module ActiveRecord
  module ConnectionAdapters
    class MysqlAdapter < AbstractAdapter
      def columns(table_name, name = nil)#:nodoc:
        sql = "SHOW FIELDS FROM #{quote_table_name(table_name)}"
        columns = []
        execute(sql, name).each do |field| 
          c = MysqlColumn.new(field[0], field[4], field[1], field[2] == "YES")
          # set primary key
          c.primary = field[3] == 'PRI'
          columns << c 
        end
        columns
      end
    end
  end
end

