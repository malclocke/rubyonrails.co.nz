# API access
class Github
  
  # Github user rornz followers
  def devs
    return YAML::load(File.read('tmp/devs.yml')) if File.exists?('tmp/devs.yml')
    @devs ||= Octopi::User.find(ROR_GITHUB_USER).followers!
    File.open('tmp/devs.yml', 'w') do |f|
      f.write @devs.to_yaml
    end
    @devs
  end
  
  def projects
    
    projects = []
    devs.each do |dev|
      file = "tmp/projects-from-#{dev.login}.yml"
      if File.exists?(file)
        projects << YAML::load(File.read(file))
      else
          begin # github returns 403 if API limit exceeded
            user_projects = select_projects(d.repositories)
            projects << user_projects
            File.open(file, 'w') do |f|
              f.write user_projects.to_yaml
            end
          rescue Exception => e
            Rails.logger.warn "API ISSUE: #{e}"
          end       
      end
    end

    projects.flatten!
  
    projects.sort_by(&:watchers).reverse
    
  end
  
  private
    def select_projects(projects)
      projects.select do |repo|
        repo.watchers > 3 && !repo.fork
      end.select do |repo|
        repo.languages.sort_by{|k,v| v}.reverse.first.first == 'Ruby' rescue false
      end
    end
  
end


