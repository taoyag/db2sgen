
module ActiveRecord
  class Base
    class << self
      def columns
        unless defined?(@columns) && @columns
          @columns = connection.columns(table_name, "#{name} Columns")
        end
        @columns
      end
    end
  end
end

