require 'eucalypt/errors'
require 'eucalypt/helpers'
require 'eucalypt/eucalypt-blog/helpers'
require 'eucalypt/eucalypt-blog/namespaces/blog/__require__'
require 'eucalypt/eucalypt-blog/namespaces/blog-article-edit/cli/edit-datetime'
require 'eucalypt/eucalypt-blog/namespaces/blog-article-edit/cli/edit-urltitle'

module Eucalypt
  class BlogArticle < Thor
    include Thor::Actions
    include Eucalypt::Helpers
    include Eucalypt::Blog::Helpers

    method_option :descending, type: :boolean, aliases: '-d', default: true
    method_option :ascending, type: :boolean, aliases: '-a', default: false
    method_option :tag, type: :string, aliases: '-t', default: String.new
    method_option :year, type: :string, aliases: '-Y'
    method_option :month, type: :string, aliases: '-M'
    method_option :day, type: :string, aliases: '-D'
    desc "list", "Display the metadata of blog articles"
    def list
      directory = File.expand_path ?.
      if File.exist? File.join(directory, '.eucalypt')
        return unless gem_check(%w[front_matter_parser rdiscount], 'eucalypt blog setup', directory)

        generator = Eucalypt::Generators::Blog.new
        generator.destination_root = directory
        generator.list(
          options[:tag],
          options[:ascending] ? :ascending : :descending,
          {year: options[:year], month: options[:month], day: options[:day]}
        )
      else
        Eucalypt::Error.wrong_directory
      end
    end

    desc "generate [URLTITLE]", "Create a new blog article"
    def generate(urltitle)
      directory = File.expand_path ?.
      if File.exist? File.join(directory, '.eucalypt')
        return unless gem_check(%w[front_matter_parser rdiscount], 'eucalypt blog setup', directory)

        generator = Eucalypt::Generators::Blog.new
        generator.destination_root = directory
        generator.article(urltitle: urltitle)
      else
        Eucalypt::Error.wrong_directory
      end
    end

    desc "destroy [URLTITLE]", "Destroys a blog article"
    def destroy(urltitle = nil)
      directory = File.expand_path ?.
      if File.exist? File.join(directory, '.eucalypt')
        return unless gem_check(%w[front_matter_parser rdiscount], 'eucalypt blog setup', directory)

        markdown_base = File.join directory, 'app', 'views', 'blog', 'markdown'
        articles_path = urltitle ? "**/#{urltitle}.md" : "**/*.md"

        articles = Dir[File.join markdown_base, articles_path]
        if articles.empty?
          Eucalypt::Error.no_articles
          return
        end

        Eucalypt::Error.delete_article_warning; puts

        asset_base = File.join directory, 'app', 'assets', 'blog'
        articles_hash = {}
        article_numbers = []
        articles.each_with_index do |article, i|
          article_numbers << (i+1).to_s
          identifier = article.split(markdown_base.gsub(/\/$/,'')<<?/).last.split('.md').first
          articles_hash[(i+1).to_s.to_sym] = identifier
          title = FrontMatterParser::Parser.parse_file(article).front_matter['title']
          puts title ? "\e[1m#{i+1}\e[0m: #{identifier} - #{title}" : "\e[1m#{i+1}\e[0m: #{identifier}"
        end

        article_number = ask("\nEnter the number of the article to delete:", limited_to: article_numbers)
        article = articles_hash[article_number.to_sym]
        delete_article = ask("\e[1;93mWARNING\e[0m: Delete article \e[1m#{article}\e[0m?", limited_to: %w[y Y Yes YES n N No NO])
        return unless %w[y Y Yes YES].include? delete_article
        remove_file File.join(markdown_base, "#{article}.md")
        paths = article.rpartition ?/
        Dir.chdir(File.join asset_base, paths.first) { FileUtils.rm_rf paths.last }

        Eucalypt::Blog::Helpers.send :clean_directory, asset_base
        Eucalypt::Blog::Helpers.send :clean_directory, markdown_base
      else
        Eucalypt::Error.wrong_directory
      end
    end

    def self.banner(task, namespace = false, subcommand = true)
      "#{basename} blog #{task.formatted_usage(self, true, subcommand).split(':').join(' ')}"
    end

    class Eucalypt::BlogArticleEdit < Thor
      def self.banner(task, namespace = false, subcommand = true)
        "#{basename} blog article #{task.formatted_usage(self, true, subcommand).split(':').join(' ')}"
      end
    end

    register(Eucalypt::BlogArticleEdit, 'edit', 'edit [COMMAND]', 'Edit blog articles')
  end
end