class Staff_listPdf < Prawn::Document
  def initialize(infos, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
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
      columnswidth=[30, 80, 150, 150, 120]
    else
      columnswidth=[30, 80, 240, 180]
    end
    table(line_item_rows, :column_widths => columnswidth, :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
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
      colcount=5
    else
      colcount=4
    end
    header = [[{content: "#{I18n.t('staff.list').upcase}<br> #{@college.name.upcase}", colspan: colcount}]]
    details=["No", I18n.t('staff.icno'), I18n.t('staff.name'), I18n.t('staff.position')]
    if @college.code=="amsas"
      header << details+[I18n.t('staff.rank_id')]
    else
      header << details
    end
    body=[]
    @infos.map do |info|
      myposts=""
      for position in info.positions
         myposts+="#{position.name}<br>"
      end
      ic_name=[@view.formatted_mykad(info.icno), info.name]
      if @college.code=="amsas"
        body << ["#{counter += 1}"]+ic_name+[myposts]+[info.try(:rank.try(:name))]
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