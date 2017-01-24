class Page_listPdf < Prawn::Document
  def initialize(pages, view, college)
    super({top_margin: 50, left_margin: 40, page_size: 'A4', page_layout: :portrait })
    @pages = pages
    @view = view
    @college=college
    font "Helvetica"
    record
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  def record
    row_count=2                 #rows for document header / title
    parent_rows=[]
    @pages.group_by{|x|x.parent}.each do |parent, pages|
       if parent.present?
	 parent_rows << row_count
	 row_count+=1
       end
       pages.each_with_index do |pg, count|
          unless @pages.pluck(:parent_id).uniq.include?(pg.id)
	    row_count+=1
	  end
       end
    end
    table(line_item_rows, :column_widths => [30, 40, 60, 150, 150, 40, 60], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      self.width=530
      for parent_row in parent_rows
        row(parent_row).background_color ='FDF8A1'
	row(parent_row).font_style=:bold
      end
    end
  end

  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('campus.pages.list').upcase}<br> #{@college.name.upcase}", colspan: 7}],
               [ 'No', 'ID', I18n.t('campus.pages.position'), I18n.t('campus.pages.navlabel'), I18n.t('campus.pages.name'), I18n.t('campus.pages.admin'), I18n.t('campus.pages.redirect')]]
    body=[]
    @pages.group_by{|x|x.parent}.each do |parent, pages|
       if parent.present?
         body << ["#{counter += 1}", parent.id, parent.position, parent.navlabel, parent.name, "#{parent.admin? ? I18n.t('yes2') : I18n.t('no2')}", "#{parent.redirect? ? I18n.t('yes2') : I18n.t('no2')}"]
       end
        pages.each_with_index do |pg, count|
          unless @pages.pluck(:parent_id).uniq.include?(pg.id)
	     body << ["#{counter += 1}", pg.id, pg.position, pg.navlabel, pg.name, "#{pg.admin? ? I18n.t('yes2') : I18n.t('no2')}", "#{pg.redirect? ? I18n.t('yes2') : I18n.t('no2')}"]
	  end
	end
    end
    header+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [470,-5]
  end

end