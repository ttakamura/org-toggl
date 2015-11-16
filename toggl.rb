require 'bundler'
Bundler.require
Dotenv.load

$LOAD_PATH << File.dirname(__FILE__) + "/lib"
require 'org_toggl'

def api
  OrgToggl.api
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

opts = Slop.parse do |o|
  o.string '-d', '--description', 'description of the timer'
  o.string '-m', '--mode',        'mode (start or stop)'
  o.string '-p', '--project',     'project name'
  o.bool   '-v', '--verbose',     'enable verbose mode'
end

case opts[:mode]
when 'start'
  res = start opts[:description], opts[:project]
  puts "Start a timer - #{res}"
when 'stop'
  res = stop
  puts "Stop the timer - #{res}"
else
  puts opts
end
