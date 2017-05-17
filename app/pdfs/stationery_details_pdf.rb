class Stationery_detailsPdf < Prawn::Document
  def initialize(stationery, view, college)
    super({top_margin: 50, left_margin: 50, page_size: 'A4', page_layout: :portrait })
    @stationery = stationery
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
    add_count=StationeryAdd.where(stationery_id: @stationery.id).count
    ded_count=StationeryUse.where(stationery_id: @stationery.id).count
    separator_row=7
    add_title=8
    add_heading=9
    separator_row2=add_heading+add_count+1
    if add_count > 0
      add_start=add_heading+1
      add_end=add_start+add_count
    end
    ded_title=separator_row2+1
    ded_heading=ded_title+1 
    
    table(line_item_rows, :column_widths => [30, 70, 120, 70, 70, 70, 70], :cell_style => { :size => 10,  :inline_format => :true, :padding => [5,5,5,5] }, :header => 2) do
      row(0..1).borders =[]
      row(1).height=40
      row(0).style size: 11
      row(0).align = :center
      row(0).font_style = :bold
      row(2..6).column(0).font_style = :bold
      row(2..6).height=20
      row(2..separator_row).borders=[]
      row(separator_row).height=30     #separator between upper & lower part
      row(separator_row2).height=30   #separator between additions & deductions
     
      column(4..6).align=:right
      if add_count > 0
        row(add_title).borders=[]
        row(add_heading).background_color = 'FFE34D'
        row(add_heading).font_style=:bold
        row(add_start..add_end).column(3).align=:right
      else
        row(add_title..add_heading).borders=[]
      end
      if ded_count > 0
        row(ded_title).borders=[]
        row(ded_heading).background_color = 'FFE34D'
        row(ded_heading).font_style=:bold
      else
        row(ded_title..ded_heading).borders=[]
      end
      row(separator_row).borders=[]
      row(separator_row2).borders=[]
    end
  end
  
  def line_item_rows
    counter = counter || 0
    additions=StationeryAdd.where(stationery_id: @stationery.id)
    deductions=StationeryUse.where(stationery_id: @stationery.id)
    header = [[{content: "#{I18n.t('stationery.title_menu').upcase}<br> #{@college.name.upcase}", colspan: 7}]]
    body=[]
    body << ["","","","","","",""]
    body << [{content: "#{I18n.t('stationery.code')}", colspan: 2}, {content: ": #{@stationery.code}", colspan: 5} ]
    body << [{content: "#{I18n.t('stationery.category')}", colspan: 2}, {content: ": #{@stationery.category}", colspan: 5} ]
    body << [{content: "#{I18n.t('stationery.quantity')}", colspan: 2}, {content: ": #{@stationery.current_quantity.to_i rescue 0} #{@stationery.unittype}", colspan: 5} ]
    body << [{content: "#{I18n.t('stationery.max')}", colspan: 2}, {content: ": #{@stationery.maxquantity.to_i} #{@stationery.unittype}", colspan: 5} ]
    body << [{content: "#{I18n.t('stationery.min')}", colspan: 2}, {content: ": #{@stationery.minquantity.to_i} #{@stationery.unittype}", colspan: 5} ]
    body << [{content: "", colspan: 7}]
    body << [{content: "<b><u>#{I18n.t('stationery.additions')}</u></b>", colspan: 7}]
    if additions.count > 0
      body << ["No", "#{I18n.t('stationery.lpono')}", "#{I18n.t('stationery.supplier_name')}", "#{I18n.t('stationery.quantity')}", "#{I18n.t('stationery.price_per_unit')}", "#{I18n.t('stationery.total')}", "#{I18n.t('stationery.received_date')}"]
      additions.each_with_index do |add, num1|
	body << [num1+1,"#{add.lpono}", "#{add.document}", "#{add.quantity}", "#{@view.ringgols(add.unitcost)}", "#{@view.ringgols(add.line_item_value)}", "#{add.received? ? add.received.strftime('%d-%m-%Y') : ""}"]
      end
    else
      body << [{content: "#{I18n.t('no_record')}", colspan: 7}]
    end
    body << [{content: "", colspan: 7}]
    body << [{content: "<b><u>#{I18n.t('stationery.deductions')}</u></b>", colspan: 7}]
    if deductions.count > 0
      body << [{content: "#{I18n.t('stationery.issues_by')}", colspan: 3}, {content: "#{I18n.t('stationery.received_by')}", colspan: 2}, "#{I18n.t('stationery.quantity')}", "#{I18n.t('stationery.issue_date')}"]
      deductions.each_with_index do |ded, num2|
        body << [num2+1, {content: "#{ded.issuesupply.try(:name)}", colspan: 2}, {content:  "#{ded.receivesupply.try(:name)}", colspan: 2}, "#{ded.quantity}", "#{ded.issuedate.strftime('%d-%m-%Y')}"]
      end
    else
      body << [{content: "#{I18n.t('no_record')}", colspan: 7}]
    end
    header+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [470,-5]
  end

end