class Staff_listPdf < Prawn::Document
  def initialize(infos, view, college)
    super({top_margin: 30, page_size: 'A4', page_layout: :portrait })
    @infos = infos
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
    if @college.code=="amsas"
      columnswidth=[30, 80, 50, 60, 160, 150]
    else
      columnswidth=[30, 80, 240, 180]
    end
    table(line_item_rows, :column_widths => columnswidth, :cell_style => { :size => 8,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      self.width=530
    end
  end
  
  def line_item_rows
    counter = counter || 0
    if @college.code=="amsas"
      colcount=6
    else
      colcount=4
    end
    header = [[{content: "#{@college.name.upcase}<br>#{I18n.t('staff.list').upcase}", colspan: colcount}]]
    if @college.code=="amsas"
      header << ["No", I18n.t('staff.icno'),I18n.t('staff.staffgrade_id'), I18n.t('staff.rank_id'), I18n.t('staff.name'), I18n.t('staff.position')]
    else
      header << ["No", I18n.t('staff.icno'), I18n.t('staff.name'), I18n.t('staff.position')]
    end
    body=[]
    @infos.map do |info|
      myposts=""
      for position in info.positions
         myposts+="#{position.name}<br>"
      end
      ic_name=[@view.formatted_mykad(info.icno), info.name]
      if @college.code=="amsas"
        body << ["#{counter += 1}"]+[@view.formatted_mykad(info.icno), info.try(:staffgrade).try(:name), info.try(:rank).try(:shortname), info.name]+[myposts]
      else
        body << ["#{counter += 1}"]+ic_name+[myposts]
      end
    end
    header+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end

end