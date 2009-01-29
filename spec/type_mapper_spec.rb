require File.expand_path("../lib/type_mapper", File.dirname(__FILE__))

describe TypeMapper, ".load_mapper :" do

  it "拡張子が無いファイルの場合はTypeMapperのインスタンス " do
    TypeMapper.load_mapper("foo").should be_instance_of TypeMapper
  end

  it "拡張子が .java の場合はJavaTypeMapperのインスタンス" do
    TypeMapper.load_mapper("foo.java").should be_instance_of JavaTypeMapper
  end
end

describe TypeMapper, "#file_name(table, filename) :" do
  before(:each) do
    @m = TypeMapper.load_mapper("foo.java")
  end
end

class Table
  attr_accessor :table_name
end


