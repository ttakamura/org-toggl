module OrgToggl
  class API
    def initialize api_token
      @api = TogglV8::API.new(api_token)
    end

    def user
      @user ||= api.me
    end

    def workspaces
      @workspaces ||= api.my_workspaces(user)
    end

    def time_entries start_time=nil, end_time=nil
      api.get_time_entries(start_time, end_time).map do |entry|
        OrgToggl::Log.new(entry)
      end
    end

    def start description, project_name=nil, wid=OrgToggl.main_workspace_id
      pid = nil
      if project_name
        if project = api.projects(wid).find{ |pj| pj["name"] == project_name }
          pid = project['id']
        else
          # pid = api.create_project('name' => project_name, 'wid' => wid)['id']
          pid = nil
        end
      end
      api.start_time_entry('description' => description,
                           'pid'         => pid,
                           'wid'         => wid)
    end

    def stop
      if timer = api.get_current_time_entry
        api.stop_time_entry(timer['id'])
      else
        "Current timer is not running"
      end
    end

    private
    def api
      @api
    end
  end
end
