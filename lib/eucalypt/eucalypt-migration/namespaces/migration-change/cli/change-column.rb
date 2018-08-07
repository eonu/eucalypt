require 'eucalypt/eucalypt-migration/namespaces/migration-change/generators/column'
require 'eucalypt/helpers'
require 'eucalypt/errors'

module Eucalypt
  class MigrationChange < Thor
    include Eucalypt::Helpers
    option :options, aliases: '-o', type: :hash, default: {}, desc: "Column options"
    desc "column [TABLE] [COLUMN] [TYPE]", "Changes a column's type definition".colorize(:grey)
    def column(table, column, type)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        migration = Eucalypt::Generators::Change::Column.new
        migration.destination_root = directory
        migration.generate(table: table, column: column, type: type, options: options[:options])
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end