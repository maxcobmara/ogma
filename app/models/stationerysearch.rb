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
  
  def received_conditions
    unless received.blank?
      ids=Stationery.joins(:stationery_adds).where('received>=?', received).pluck(:stationery_id).uniq
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
    end
  end
  
  def received2_conditions
    unless received2.blank?
      ids=Stationery.joins(:stationery_adds).where('received<=?', received2).pluck(:stationery_id).uniq
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
    end
  end
  
  def issuedate_conditions
    unless issuedate.blank?
      ids=Stationery.joins(:stationery_uses).where('issuedate>=?', issuedate).pluck(:stationery_id).uniq
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
    end
  end
  
  def issuedate2_conditions
    unless issuedate2.blank?
      ids=Stationery.joins(:stationery_uses).where('issuedate<=?', issuedate2).pluck(:stationery_id).uniq
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
    end
  end
  
  def issuedby_conditions
    unless issuedby.blank?
      ids=Stationery.joins(:stationery_uses).where('issuedby=?', issuedby)
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
    end
  end
  
  def receivedby_conditions
    unless receivedby.blank?
      ids=Stationery.joins(:stationery_uses).where('receivedby=?', receivedby)
      if ids.count > 0
        a="id=?" 
        0.upto(ids.count-2) do |x|
          a+=" OR id=? "
        end
        ["("+a+")", ids] 
      else
        [" (id=?)", 0]  # NOTE - refer above
      end
    end
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