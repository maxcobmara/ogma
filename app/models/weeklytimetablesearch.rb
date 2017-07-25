class Weeklytimetablesearch < ActiveRecord::Base
  attr_accessor :intake_programme
  
  before_save :update_intake
  
  belongs_to :college
  
  def weeklytimetables
    @weeklytimetables ||= find_weeklytimetables
  end
  
  def validintake_data  #get valid Wtimetable_ids
    Weeklytimetable.validintake_timetable
  end
  
  def update_intake
    unless intake_programme.blank?
      siri=intake_programme.split(" |")[0].gsub("Siri ", "")
      intakeid=Intake.where("name ILIKE(?)", "%#{siri}%").first.id
      self.intake_id=intakeid
    end
  end
  
  private

  def find_weeklytimetables
    Weeklytimetable.where(conditions).order(orders)   
  end
  
  def validintake_details
    a="id=?" if validintake_data.count > 0
    0.upto(validintake_data.count-2) do |cnt|
      a+=" OR id=? "
    end
    return a if validintake==1 || validintake=='1'
  end
  
  def validintake_conditions
    ["("+validintake_details+")", validintake_data] if validintake==1 || validintake=='1'
  end
  
  def intake_id_conditions
    ["intake_id=?", intake_id] if !intake_id.blank? && (intake==1 || intake=='1') 
  end
  
  def preparedby_conditions
    ["prepared_by=?", preparedby] unless preparedby.blank? 
  end
  
  def startdate_conditions
    ["startdate >=?", startdate] unless startdate.blank? 
  end
  
  def enddate_conditions
    ["startdate<=?", enddate] unless enddate.blank? 
  end
  
  def orders
    "id ASC"
  end  

  def conditions
    [conditions_clauses.join(' AND '), *conditions_options] #works like OR?????
  end

  def conditions_clauses
    conditions_parts.map { |condition| condition.first }
  end

  def conditions_options
    conditions_parts.map { |condition| condition[1..-1] }.flatten
  end

  def conditions_parts
    private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
  end
  
end
