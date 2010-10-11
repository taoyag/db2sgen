require 'rubygems'
require 'activerecord'
require 'erb'
require 'fileutils'
require 'logger'

require File.expand_path('definitions', File.dirname(__FILE__))
require File.expand_path('type_mapper', File.dirname(__FILE__))
require File.expand_path('ext_activerecord', File.dirname(__FILE__))
require File.expand_path('connection_adapters/ext_adapter', File.dirname(__FILE__))

#
# データベースのテーブル情報とテンプレートファイルから
# ソースファイルを生成する.
#
class SourceGenerator
  attr_accessor :config, :template_dir, :out_dir

  def initialize(config)
    @config = config
  end

  # configに格納されたテーブル情報と
  # テンプレートファイルから
  # ソースファイルを生成する
  def generate
    setup
    collect_tables
    output
  end

  # ソースファイル生成の準備
  def setup
    ActiveRecord::Base.establish_connection config['database']
    AdapterLoader.load config['database']

    @template_dir = config['template_dir']
    @out_dir      = config['out_dir']
  end

  # データベースに接続し
  # テーブル情報を収集する
  def collect_tables
    log "collect table definitions..."
    @tables = TableDefinition.collect config['tables']
    log "tables.size = #{@tables.size}"
  end

  # テンプレートファイルを読み込み
  # ソースファイルを生成する
  def output
    template_files do |f|
      log "load template file. #{f}"
      @tables.each do |table|
        out table, f
      end
    end
  end

  # template_dirで定義された
  # テンプレートファイルデイレクトリから
  # テンプレートファイルを取得する
  def template_files
    files = []
    Dir.glob("#{@template_dir}/**/*") do |f|
      next unless File.file? f
      file = f.sub("#{@template_dir}/", '')
      yield(file) if block_given?
      files << file
    end
    files
  end

  # ソースファイルを出力する
  #
  # [table]    データベースの1テーブル
  # [template] テンプレートファイル
  def out(table, template)
    m    = load_mapper template
    erb  = setup_erb   template
    file = setup_file  table, template, m

    File.open(file, "w") do |f|
      f.write erb.result(binding)
      log "output file. #{file}"
    end
  end

  def log(message)
    @logger ||= Logger.new(STDOUT)
    @logger.info(message)
  end

  def load_mapper(template)
    TypeMapper.load_mapper template
  end
  
  def setup_erb(template)
    ERB.new(File.read(File.expand_path(template, @template_dir)), nil, '-')
  end

  def setup_file(table, template, mapper)
    file = File.expand_path(mapper.file_name(table, template), @out_dir)
    FileUtils.mkdir_p(File.dirname(file)) unless FileTest.exist?(File.dirname(file))
    file
  end
end
