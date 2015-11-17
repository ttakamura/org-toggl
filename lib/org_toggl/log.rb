# coding: utf-8
module OrgToggl
  class Log
    def initialize entry
      @entry = entry
    end

    def id
      @entry['id']
    end

    def description
      @entry['description']
    end

    def start_at
      Time.parse @entry['start']
    end

    def stop_at
      Time.parse @entry['stop']
    end

    def done?
      !!@entry['stop']
    end

    def logged_to_calendar! cal_event
      db[db_key] = {'calendar_id' => cal_event.id}
    end

    def logged_to_calendar?
      !!db[db_key]
    end

    private
    def db
      OrgToggl.db
    end

    def db_key
      "toggl_log_#{id}"
    end
  end
end

# {"id"=>1,
#  "wid"=>4,
#  "pid"=>2,
#  "billable"=>false,
#  "start"=>"2015-11-09T20:25:03+00:00",
#  "stop"=>"2015-11-09T20:55:59+00:00",
#  "duration"=>1856,
#  "description"=>"朝のコーヒー",
#  "tags"=>["mobile"],
#  "duronly"=>false,
#  "at"=>"2015-11-09T21:00:16+00:00",
#  "uid"=>3}
