require 'conflux/command/abstract_command'
require_relative '../api/addons'
require_relative '../pull'

class Conflux::Command::Addons < Conflux::Command::AbstractCommand

  def index
    if ![0, 2].include?(@args.length) || (@args.length == 2 && @args[0] != '-a')
      # return command help
      return
    end

    app_slug = @args[1]

    headers = conditional_headers(@args.empty?)

    endpoint = app_slug.nil? ? '/for_app' : "/for_app?app_slug=#{app_slug}"

    RestClient.get("#{host_url}/addons#{endpoint}", headers) do |response|
      if response.code == 200
        addons = JSON.parse(response.body) rescue {}
        puts to_table(addons, ['slug', 'name', 'plan', 'cost'])
      else
        error('Error making request')
      end
    end
  end

  def all
    addons = Conflux::Api::Addons.new.all
    puts to_table(addons, ['slug', 'name', 'description'])
    puts "\nSee plans with conflux addons:plans ADDON"
  end

  def add
    if ![1, 3].include?(@args.length) || (@args.length == 3 && @args[1] != '-a')
      # return command help
      return
    end

    addon_slug, plan = @args.first.split(':')
    app_slug = @args[2]

    headers = conditional_headers(app_slug.nil?)

    data = {
      app_slug: app_slug,
      addon_slug: addon_slug,
      plan: plan
    }

    RestClient.post("#{host_url}/app_addons", data, headers) do |response|
      if response.code == 200
        body = JSON.parse(response.body) rescue {}
        display "Successfully added #{addon_slug} to #{body['app_slug'] || app_slug}."
        Conflux::Pull.perform
      else
        error "Error adding #{addon_slug} as an addon."
      end
    end
  end

  #----------------------------------------------------------------------------

  module CommandInfo

    module Index
      DESCRIPTION = 'List addons for a specific conflux app'
    end

    module All
      DESCRIPTION = 'List all available addons'
      VALID_ARGS = {}
    end

    module Add
      DESCRIPTION = 'Add an addon to a conflux app'
    end

  end

end