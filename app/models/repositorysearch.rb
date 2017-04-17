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
  
  def refno=(value)
    keyword[:refno] = value
  end
  
  def refno
    keyword[:refno]
  end
  
  def publish_date=(value)
    keyword[:publish_date] = value
  end
  
  def publish_date
    keyword[:publish_date]
  end
  
  def total_pages=(value)
    keyword[:total_pages] = value
  end
  
  def total_pages
    keyword[:total_pages]
  end
  
  def copies=(value)
    keyword[:copies] = value
  end
  
  def copies
    keyword[:copies]
  end
  
  def location=(value)
    keyword[:location] = value
  end
  
  def location
    keyword[:location]
  end
  
  def repositories
    @repositories ||= find_repositories
  end
  
  private

  def find_repositories
    Repository.digital_library.where(conditions).order(orders)
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
  
  # TODO -start
  def document_type_conditions
  end 
  
  def document_subtype_conditions
  end
  
  def refno_conditions
  end
  
  def publish_date_conditions
  end 
  
  def total_pages_conditions
  end 
  
  def copies_conditions
  end
  
  def location_conditions
  end
  # TODO -end
  
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
