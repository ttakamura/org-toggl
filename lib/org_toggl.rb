class OrgToggl
  class << self
    def api_token
      ENV['TOGGL_TOKEN']
    end

    def api
      @api ||= TogglV8::API.new(api_token)
    end

    def user
      @user ||= api.me
    end

    def workspaces
      @workspaces ||= api.my_workspaces(user)
    end

    def main_workspace_id
      workspaces.first['id']
    end
  end
end
