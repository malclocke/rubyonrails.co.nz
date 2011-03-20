class PagesController < ApplicationController
  
  def home
    github = Github.new
    
    @developers = github.devs
    @projects = github.projects
    
    @events = RailsCalendar.new.events
  end
  
  def reset
    begin
      ['events', 'devs', 'projects'].each do |file|
        File.unlink("tmp/#{file}.yml")
      end

      render :text => "done"
    rescue
      render :text => "no files to remove"
    end
  end

end
