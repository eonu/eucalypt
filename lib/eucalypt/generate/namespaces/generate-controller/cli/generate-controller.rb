require 'eucalypt/generate/namespaces/generate-controller/generators/controller'
require 'eucalypt/app'
require 'eucalypt/errors'
require 'eucalypt/helpers'

module Eucalypt
  class Generate < Thor
    include Eucalypt::Helpers
    using Colorize
    option :spec, type: :boolean, default: true, desc: "Include a controller spec file"
    option :rest, aliases: '-r', type: :boolean, default: false,  desc: "Generate REST routes for the controller"
    desc "controller [NAME]", "Generates a controller".colorize(:grey)
    def controller(name)
      directory = File.expand_path('.')
      if Eucalypt.app? directory
        controller = Eucalypt::Generators::Controller.new
        controller.destination_root = directory
        controller.generate(
          name: name,
          spec: options[:spec],
          rest: options[:rest]
        )
      else
        Eucalypt::Error.wrong_directory
      end
    end
  end
end