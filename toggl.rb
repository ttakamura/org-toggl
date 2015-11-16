require 'bundler'
Bundler.require
Dotenv.load

opts = Slop.parse do |o|
  o.string '-d', '--description', 'description of the timer'
  o.string '-m', '--mode',        'mode (start or stop)'
  o.string '-p', '--project',     'project name'
  o.bool   '-v', '--verbose',     'enable verbose mode'
end

case opts[:mode]
when 'start'
  start
when 'stop'
  stop
else
  puts opts
end
