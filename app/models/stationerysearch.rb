class Stationerysearch < ActiveRecord::Base
  belongs_to :college
  
  def stationeries
    @stationeries ||= find_stationeries
  end
  
  private

  def find_stationeries
    Stationery.where(conditions).order(orders)   
  end
  
  def product_conditions
    unless product.blank? 
      if product.include?(" | ")
        item_code, product_name=product.split(" | ")
        ["(category ILIKE (?) or code ILIKE (?))", "%#{product_name}%", "%#{item_code}%"] 
      else
        ["(category ILIKE (?) or code ILIKE (?))", "%#{product}%", "%#{product}%"]
      end
    end
  end

  def document_conditions
    unless document.blank?
      if document.blank? == false && document.include?("|") ==true
        ids=Stationery.joins(:stationery_adds).where('document ILIKE(?)', "%#{document.split(" | ")[0]}%").pluck(:stationery_id).uniq
      elsif document.blank? == false && document.include?("|") ==false
        ids=Stationery.joins(:stationery_adds).where('document ILIKE(?) OR lpono ILIKE(?)',  "%#{document}%", "%#{document}%").pluck(:stationery_id).uniq
      end
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - workaround to ensure ALL records NOT TO BE DISPLAYED should this is the only search criteria used & no stationery rec exist - 16May2017
      end
    end
  end
  
  def received_details
    exist = StationeryAdd.where('received>=?', received).count
    a='id=? ' if StationeryAdd.where('received>=?', received).map(&:stationery_id).uniq.count!=0
    0.upto(StationeryAdd.where('received>=?', received).map(&:stationery_id).uniq.count-2) do |l|  
      a=a+'OR id=? '
    end 
    return a if exist > 0 && received.blank? == false
  end
  def received_conditions  
    ["( "+received_details+")", StationeryAdd.where('received>=?', received).map(&:stationery_id).uniq] if (StationeryAdd.where('received>=?', received).count) > 0 && received.blank? == false 
  end

  def received2_details
    exist = StationeryAdd.where('received<=?', received2).count
    a='id=? ' if StationeryAdd.where('received<=?', received2).map(&:stationery_id).uniq.count!=0
    0.upto(StationeryAdd.where('received<=?', received2).map(&:stationery_id).uniq.count-2) do |l|  
      a=a+'OR id=? '
    end 
    return a if exist > 0 && received2.blank? == false
  end
  def received2_conditions  
    ["( "+received2_details+")", StationeryAdd.where('received<=?', received2).map(&:stationery_id).uniq] if (StationeryAdd.where('received<=?', received2).count) > 0 && received2.blank? == false 
  end
  
  #-------
  
  def issuedate_details
    exist = StationeryUse.where('issuedate>=?', issuedate).count
    a='id=? ' if StationeryUse.where('issuedate>=?', issuedate).map(&:stationery_id).uniq.count!=0
    0.upto(StationeryUse.where('issuedate>=?', issuedate).map(&:stationery_id).uniq.count-2) do |l|  
      a=a+'OR id=? '
    end 
    return a if exist > 0 && issuedate.blank? == false
  end
  def issuedate_conditions  
    ["( "+issuedate_details+")", StationeryUse.where('issuedate>=?', issuedate).map(&:stationery_id).uniq] if (StationeryUse.where('issuedate>=?', issuedate).count) > 0 && issuedate.blank? == false 
  end

  def issuedate2_details
    exist = StationeryUse.where('issuedate<=?', issuedate2).count
    a='id=? ' if StationeryUse.where('issuedate<=?', issuedate2).map(&:stationery_id).uniq.count!=0
    0.upto(StationeryUse.where('issuedate<=?', issuedate2).map(&:stationery_id).uniq.count-2) do |l|  
      a=a+'OR id=? '
    end 
    return a if exist > 0 && issuedate2.blank? == false
  end
  def issuedate2_conditions  
    ["( "+issuedate2_details+")", StationeryUse.where('issuedate<=?', issuedate2).map(&:stationery_id).uniq] if (StationeryUse.where('issuedate<=?', issuedate2).count) > 0 && issuedate2.blank? == false 
  end
  
  
#   def received_conditions
#     ["received>=?", received] unless received.blank?
#   end
#   def received2_conditions  #between 2 dates
#     ["received<=?", received2] unless received2.blank?
#   end
  
  def issuedby_details
    exist = StationeryUse.where('issuedby=?', issuedby).count
    a='id=? ' if StationeryUse.where('issuedby=?', issuedby).map(&:stationery_id).uniq.count!=0
    0.upto(StationeryUse.where('issuedby=?', issuedby).map(&:stationery_id).uniq.count-2) do |l|  
      a=a+'OR id=? '
    end 
    return a if exist > 0 && issuedby.blank? == false
  end
  def issuedby_conditions  
    ["( "+issuedby_details+")",StationeryUse.where('issuedby=?', issuedby).map(&:stationery_id).uniq] if (StationeryUse.where('issuedby=?', issuedby).count) > 0 && issuedby.blank? == false 
  end
  
  def receivedby_details
    exist = StationeryUse.where('receivedby=?', receivedby).count
    a='id=? ' if StationeryUse.where('receivedby=?', receivedby).map(&:stationery_id).uniq.count!=0
    0.upto(StationeryUse.where('receivedby=?', receivedby).map(&:stationery_id).uniq.count-2) do |l|  
      a=a+'OR id=? '
    end 
    return a if exist > 0 && receivedby.blank? == false
  end
  def receivedby_conditions  
    ["( "+receivedby_details+")", StationeryUse.where('receivedby=?', receivedby).map(&:stationery_id).uniq] if (StationeryUse.where('receivedby=?', receivedby).count) > 0 && receivedby.blank? == false 
  end
  
  ################
  
  def orders
    "code ASC"# "staffgrade_id ASC"
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