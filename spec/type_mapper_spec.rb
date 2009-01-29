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
    @filename = "foo/bar/Table.java"
    @table = Table.new
    @m = TypeMapper.load_mapper(@filename)
  end

  it "ファイル名table.javaが変換できる " do
    @filename = "foo/bar/table.java"
    @table.table_name = "user_company"
    @m.file_name(@table, @filename).should == 'foo/bar/userCompany.java'
  end
  
  it "ファイル名Table.javaが変換できる " do
    @filename = "foo/bar/Table.java"
    @table.table_name = "user_company"
    @m.file_name(@table, @filename).should == 'foo/bar/UserCompany.java'
  end
end

describe TypeMapper, "#class_name(table) :" do
  before(:each) do
    @table = Table.new
    @m = TypeMapper.load_mapper('foo/bar/table.java')
  end

  it "'user_company' を渡すと 'UserCompany' が返される" do
    @table.table_name = "user_company"
    @m.class_name(@table).should == 'UserCompany'
  end
end

describe TypeMapper, "#name(column) :" do
  before(:each) do
    @column = Column.new
    @m = TypeMapper.load_mapper('foo/bar/table.java')
  end

  it "column#name が返される" do
    @column.name = 'id'
    @m.name(@column).should == @column.name
  end
end

describe TypeMapper, "#type_name(column) :" do
  before(:each) do
    @column = Column.new
    @m = MockTypeMapper.new
  end

  it "Column#type がstringの場合、TypeMapper#type_string が呼び出される" do
    @column.type = :string
    class << @m
      def type_string
      'string called'
      end
    end
    @m.type_name(@column).should == @m.type_string
  end

  it "Column#type がintegerの場合、TypeMapper#type_integer が呼び出される" do
    @column.type = :integer
    class << @m
      def type_integer
      'integer called'
      end
    end
    @m.type_name(@column).should == @m.type_integer
  end
end

class MockTypeMapper < TypeMapper
end

class Table
  attr_accessor :table_name
end

class Column
  attr_accessor :name, :type
end

