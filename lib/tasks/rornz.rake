require 'rake/clean'
CLEAN = ["tmp/events.yml", "tmp/devs.yml", FileList["tmp/projects-from-*.yml"]]

namespace :rornz do

  desc "Refresh all generated files"
  task :refresh => [:clean, :events, :devs, :projects]

  desc "Build the events file"
  task :events => ["tmp/events.yml"]

  desc "Build the devs.yml file"
  task :devs => ["tmp/devs.yml"]

  desc "Build the user projects files"
  task :projects => [:environment] do |t|
    puts "loading projects"
    Github.new.projects
  end

  file "tmp/events.yml" => [:environment] do |t|
    RailsCalendar.new.events
  end

  file "tmp/devs.yml" => [:environment] do |t|
    Github.new.devs
  end

end
