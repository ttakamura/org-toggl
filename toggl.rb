# coding: utf-8
require 'bundler'
Bundler.require
require 'active_support'
require 'active_support/core_ext'
Dotenv.load

$LOAD_PATH << File.dirname(__FILE__) + "/lib"
require 'org_toggl'

def api
  OrgToggl.api
end

def cal
  OrgToggl.calendar
end

def parse_desc description
  if description
    OrgToggl.logger.error("parse_desc# #{ description }")
    # input =>                 [0:00 (英辞郎 for Mac.dict を買う)]
    if m = description.match(/\[.+? \((.+)\)\]/)
      m[1]
    # input =>                    [0:37/2:00] (session変数など、古いルーチンを廃止)
    elsif m = description.match(/\[.+?\] \((.+)\)/)
      m[1]
    else
      description
    end
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
  desc = parse_desc(opts[:description])
  res  = api.start desc, opts[:project]
  puts "Start a timer - #{res}"
when 'stop'
  res = api.stop
  puts "Stop the timer - #{res}"
when 'sync_calendar'
  unsync_logs = api.time_entries.find_all{ |l| !l.logged_to_calendar? && l.done? }
  unsync_logs.each do |log|
    cal.post_log log
  end
  puts "Success sync to calender"
when 'debug'
  debugger
  puts "Time to debug..."
else
  puts opts
end
