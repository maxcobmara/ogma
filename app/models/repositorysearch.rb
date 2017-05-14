class Repositorysearch < ActiveRecord::Base
  belongs_to :college
  
  serialize :keyword, Hash
  serialize :data, Hash
  
  def title=(value)
    keyword[:title] = value
  end
  
  def title
    keyword[:title]
  end
  
  def vessel=(value)
    keyword[:vessel] = value
  end
  
  def vessel
    keyword[:vessel]
  end
  
  def document_type=(value)
    keyword[:document_type] = value
  end
  
  def document_type
    keyword[:document_type]
  end
  
  def document_subtype=(value)
    keyword[:document_subtype] = value
  end
  
  def document_subtype
    keyword[:document_subtype]
  end
  
  def equipment=(value)
    keyword[:equipment] = value
  end
  
  def equipment
    keyword[:equipment]
  end
  
  def refno=(value)
    keyword[:refno] = value
  end
  
  def refno
    keyword[:refno]
  end
  
  def repotype=(value)
    data[:repotype] = value
  end
  
  def repotype
    data[:repotype]
  end
  
  def classification=(value)
    data[:classification]=value
  end
  
  def classification
    data[:classification]
  end
  
  def self.classification_selection
    existing=(Repository.all.map(&:classification).compact-[""].uniq)   #["1"], ["Restricted", "1"], ["Confidential", "2"], ["Secret", "3"]] 
    selection=[]
    Repository.document_classification.each{|c| selection << c if existing.include?(c[1]) }
    selection
  end
  
  def repositories
    @repositories ||= find_repositories
  end
  
  private

  def find_repositories
    if repotype=='1'
      Repository.where(data: nil).where(conditions).order(orders)
    elsif repotype=='2'
      Repository.digital_library.where(conditions).order(orders)
    end
  end
  
  def title_conditions
    ['title ILIKE ?', "%#{title}%"] unless title.blank?
  end
  
  def vessel_conditions
    unless vessel.blank?
      ids=Repository.vessel_search(vessel).pluck(:id)
      a="id=?" if ids.count > 0
      0.upto(ids.count-2) do |x|
        a+=" OR id=? "
      end
      ["("+a+")", ids]
    end
  end

  def document_type_conditions
    unless document_type.blank?
      ids=Repository.document_type_search(document_type).pluck(:id)
      a="id=?" if ids.count > 0
      0.upto(ids.count-2) do |x|
        a+=" OR id=? "
      end
      ["("+a+")", ids]
    end
  end 
  
  def document_subtype_conditions
    unless document_subtype.blank?
      ids=Repository.document_subtype_search(document_subtype).pluck(:id)
      a="id=?" if ids.count > 0
      0.upto(ids.count-2) do |x|
        a+=" OR id=? "
      end
      ["("+a+")", ids]
    end
  end
  
  ###
  def equipment_conditions
    unless equipment.blank?
      ids=Repository.equipment_search(equipment).pluck(:id)
      a="id=?" if ids.count > 0
      0.upto(ids.count-2) do |x|
        a+=" OR id=? "
      end
      ["("+a+")", ids]
    end
  end
  ###
  
  def refno_conditions
    unless refno.blank?
      ids=Repository.refno_search(refno).pluck(:id)
      a="id=?" if ids.count > 0
      0.upto(ids.count-2) do |x|
        a+=" OR id=? "
      end
      ["("+a+")", ids]
    end
  end
  
  def classification_conditions
    unless classification.blank?
      ids=Repository.classification_search(classification).pluck(:id)
      a="id=?" if ids.count > 0
      0.upto(ids.count-2) do |x|
        a+=" OR id=? "
      end
      ["("+a+")", ids] if ids.count > 0
    end
  end
  
  def orders
   "title ASC"
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
