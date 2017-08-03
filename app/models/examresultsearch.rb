class Examresultsearch < ActiveRecord::Base
  attr_accessor :intake_programme
  
  before_save :update_intake
  
  belongs_to :college
  
  def examresults
    @examresults ||= find_examresults
  end
  
  def update_intake
    unless intake_programme.blank?
      if college.code=='amsas'
        siri=intake_programme.split(" |")[0].gsub("Siri ", "")
        intakeid=Intake.where("name ILIKE(?)", "%#{siri}%").first.id
        self.intake_id=intakeid
      else
        #2.1.4 :034 > "May 2007 (23)".scan(/\(([^\/.]*)\)/)
        #=> [["23"]] 
        #2.1.4 :035 > "May 2007 (23)".split(" (")[0]
        #=> "May 2007"
        intake_group=intake_programme.scan(/\(([^\/.]*)\)/)
        intake_name=intake_programme.split(" (")[0]
        intakeid=Intake.where("name ILIKE(?) AND description ILIKE(?)", "%#{intake_name}%", "%#{intake_group}%").first.id
	self.intake_id=intakeid
      end
    end
  end
  
  private

  def find_examresults
    Examresult.where(conditions).order(orders)   
  end

  def intake_id_conditions
    ["intake_id=?", intake_id] unless intake_id.blank?      
  end
  
  def semester_conditions
    ["semester=?", semester] unless semester.blank?
  end
  
  def examdts_conditions
    ["examdts=?", examdts] unless examdts.blank?
  end
  
  def examdte_conditions
    ["examdte=?", examdte] unless examdte.blank?
  end
  
  def orders
    "examdts ASC"
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
