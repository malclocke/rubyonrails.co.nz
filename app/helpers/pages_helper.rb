module PagesHelper
  
  def parse_date(when_field)
    # grab the first line
    when_field = when_field.to_s.split("\n").first
    
    # remove the when:
    when_field.gsub!(/^When:\ /, '')
    when_field = when_field.split(" to ").first

    Date.parse(when_field)
  end
  
end
