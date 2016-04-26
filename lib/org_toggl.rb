module OrgToggl
  class << self
    def api_token
      ENV['TOGGL_TOKEN']
    end

    def api
      @api ||= OrgToggl::API.new(api_token)
    end

    def db
      @db ||= OrgToggl::DB.new("db/toggl.yaml")
    end

    def calendar
      @calendar ||= OrgToggl::Calendar.new(ENV['CAL_CLIENT_ID'], ENV['CAL_CLIENT_SEC'], ENV['CALENDAR_ID'])
    end

    def main_workspace_id
      api.workspaces.first['id']
    end

    def logger
      @logger ||= Logger.new('log/toggl.log')
    end
  end
end

require 'org_toggl/api'
require 'org_toggl/db'
require 'org_toggl/calendar'
require 'org_toggl/log'
