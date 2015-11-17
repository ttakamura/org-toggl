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

    def main_workspace_id
      api.workspaces.first['id']
    end
  end
end

require 'org_toggl/api'
require 'org_toggl/db'
