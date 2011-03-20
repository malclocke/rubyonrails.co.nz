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
    return YAML::load(File.read('tmp/projects.yml')) if File.exists?('tmp/projects.yml')
    # get all projects
    
    projects = []
    devs.each do |d|
      begin
       projects << d.repositories
      rescue
        
      end
    end
    projects.flatten!
    # select only popular and non forked repos
    projects = projects.select do |repo|
      repo.watchers > 3 && !repo.fork
    end

    projects = projects.select do |repo|
      repo.languages.sort_by{|k,v| v}.reverse.first.first == 'Ruby' rescue false
    end
  
    @projects = projects.sort_by(&:watchers).reverse
    
    File.open('tmp/projects.yml', 'w') do |f|
      f.write @projects.to_yaml
    end
    
    @projects
  end
  
end


