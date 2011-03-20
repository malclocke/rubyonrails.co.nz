class RailsCalendar
  def events
    require 'open-uri'
    return YAML::load(File.read('tmp/events.yml')) if File.exists?('tmp/events.yml')
    url = URI.parse(ROR_CALENDAR)
    cal = url.read
    cal = Hash.from_xml(cal)
    @cal = cal['feed']['entry'].select{|event| Time.parse(event['published']) > 1.year.ago}
    File.open('tmp/events.yml','w'){|f| f.write @cal.to_yaml}
    @cal
  end
end


