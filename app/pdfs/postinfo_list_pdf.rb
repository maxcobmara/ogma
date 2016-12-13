class Postinfo_listPdf < Prawn::Document
  def initialize(postinfos, view, college)
    super({top_margin: 30, left_margin: 30, page_size: 'A4', page_layout: :portrait })
    @postinfos = postinfos
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
    rec_count=@postinfos.count+1
    table(line_item_rows, :column_widths => [30, 155, 240, 45, 60], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      row(2..rec_count).column(4).align = :right
      self.width=530
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{@college.code=='amsas' ? I18n.t('staff.postinfos.title2').upcase :  I18n.t('staff.postinfos.title').upcase}<br> #{@college.name.upcase}", colspan: 5}],
              [ 'No', I18n.t('staff.postinfos.details'), I18n.t('staff.postinfos.position'), I18n.t('staff.postinfos.staffgrade_id'), I18n.t('staff.postinfos.post_count')]]
    body=[]
    @postinfos.each do |postinfo|
        cnt=cnt||0
        plist=""
        postinfo.positions.each {|post|plist+="#{cnt+=1}. #{post.name_unit}<br>"}
        body << ["#{counter += 1}", postinfo.details, "#{postinfo.positions.blank? ? "" : "#{plist}"}", postinfo.employgrade.name, postinfo.post_count]
    end
    header+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end

end