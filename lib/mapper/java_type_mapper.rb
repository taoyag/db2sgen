class JavaTypeMapper < TypeMapper

  def name(column)
    column.name.camelize(:lower)
  end
  
  def type_string
    'String'
  end

  def type_integer
    'Integer'
  end

  def type_datetime
    'Date'
  end
end
