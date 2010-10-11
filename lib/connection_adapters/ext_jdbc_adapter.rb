module ActiveRecord
  module ConnectionAdapters #:nodoc:
    class JdbcAdapter < AbstractAdapter
      def columns(table_name, name = nil) #:nodoc:
        puts 'columns....'
        (owner, table_name) = @connection.describe(table_name)

        #TODO primary key
        table_cols = <<-SQL
            select column_name as name, data_type as sql_type, data_default, nullable,
                   decode(data_type, 'NUMBER', data_precision,
                                     'FLOAT', data_precision,
                                     'VARCHAR2', data_length,
                                     'CHAR', data_length,
                                      null) as limit,
                   decode(data_type, 'NUMBER', data_scale, null) as scale
              from all_tab_columns
             where owner      = '#{owner}'
               and table_name = '#{table_name}'
             order by column_id
          SQL

        select_all(table_cols, name).map do |row|
          limit, scale = row['limit'], row['scale']
          if limit || scale
            row['sql_type'] << "(#{(limit || 38).to_i}" + ((scale = scale.to_i) > 0 ? ",#{scale})" : ")")
          end

          # clean up odd default spacing from Oracle
          if row['data_default']
            row['data_default'].sub!(/^(.*?)\s*$/, '\1')
            row['data_default'].sub!(/^'(.*)'$/, '\1')
            row['data_default'] = nil if row['data_default'] =~ /^(null|empty_[bc]lob\(\))$/i
          end

          OracleColumn.new(oracle_downcase(row['name']),
                           row['data_default'],
                           row['sql_type'],
                           row['nullable'] == 'Y')
        end
      end
    end
  end
end

