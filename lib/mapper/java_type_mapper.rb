class JavaTypeMapper < TypeMapper

  def name(column)
    column.name.camelize(:lower)
  end
  
  def type_string(column)
    'String'
  end

  def type_integer(column)
    'Long'
    #puts column.precision
    #puts column.type
    #puts column.sql_type
    #puts column.scale
    #puts column.limit
    #if column.precision > 1
    #  'Long'
    #else
    #  'Integer'
    #end
  end

  def type_decimal(column)
    'Long'
#    if column.scale > 0
#      'java.math.BigDecimal'
#    else
#      'Long'
#    end
  end

  def type_datetime(column)
    'Date'
  end
end
