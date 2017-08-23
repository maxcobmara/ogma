module EventsHelper
  
  def dayname(str)
    I18n.t(:'date.abbr_day_names')[str]
  end
  
  def start_str
    dname=dayname(start_at.wday)
    if college.code=='amsas'
      a="#{start_at.try(:strftime, "%d-%m-%Y")}, #{dname}, #{start_at.try(:strftime, "%H:%M")}"
    else
      a="#{start_at.try(:strftime, "%d %b %y")}, #{dname}, #{end_at.try(:strftime, "%I:%M %P")}"
    end
    a
  end
  
  def end_str
    dname=dayname(end_at.wday)
    if college.code=='amsas'
      a="#{end_at.try(:strftime, "%d-%m-%Y")}, #{dname}, #{end_at.try(:strftime, "%H:%M")}"
    else
      a="#{end_at.try(:strftime, "%d %b %y")}, #{dname}, #{end_at.try(:strftime, "%I:%M %P")}"
    end
    a
  end
  
end