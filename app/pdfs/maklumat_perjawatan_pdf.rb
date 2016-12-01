class Maklumat_perjawatanPdf < Prawn::Document
  def initialize(position, college, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :landscape })
    @positions = position
    @college = college
    @view = view
    font "Helvetica"
    text "LAMPIRAN A", :align => :right, :size => 11, :style => :bold
    move_down 5
    text "MAKLUMAT PERJAWATAN DI KOLEJ-KOLEJ LATIHAN", :align => :center, :size => 11, :style => :bold
    text "#{'KEMENTERIAN KESIHATAN MALAYSIA' if @college.code=='kskbjb'}", :align => :center, :size => 11, :style => :bold
    text "#{'PUSAT PENDIDIKAN DAN LATIHAN AGENSI PENGUATKUASAAN MARITIM MALAYSIA' if @college.code=='amsas'}", :align => :center, :size => 11, :style => :bold
    text "SEHINGGA #{I18n.l((Position.all.order(updated_at: :desc).pluck(:updated_at).first), format: '%d-%m-%Y')}", :align => :center, :size => 11, :style => :bold   
    move_down 10
    text "KOLEJ: #{@college.name.upcase}", :align => :left, :size => 11, :style => :bold    
    jawatan

    #bounding_box([50, 500], :width => 200, :height => 300) do
    #stroke_bounds
    #end
    
    #repeat(lambda{|page_number| page_number!=1}) do
      ##horizontal_rule
      ##stroke_bounds
       #stroke do
         #horizontal_line 0, 280, :at => [bounds.top]
       #end
    #end
    #repeat :all do
      #stroke do
        #horizontal_line 0, 280, :at => [bounds.bottom]
        #horizontal_line 0, 280, :at => [bounds.absolute_bottom]
        ##horizontal_line 0, 280, :at => y
        ##horizontal_line 200, 500, :at => 150
      #end
    #end
  end
  
  def jawatan
    #butiran_heading_rows=[]
    #butiran_not_exist=[]
    #butiran_exist=[]
    #@positions.each_with_index do |position, ind|
      #postcount=position.totalpost.to_i
      #if postcount > 0
        #butiran_heading_rows << ind+2    #butiran heading
      #else
        #if position.postinfo_id.blank?
          #butiran_not_exist << ind+2         #butiran not exist 
        #else
          #butiran_exist << ind+2                #butiran exist (other than heading)
        #end
      #end
    #end
    
    #border_width - 3rd one - bottom
    #:border_width => [1, 1, 1, 1], borders: [:left, :right, :top, :bottom], :header =>true
    table(line_item_rows , :column_widths => [23, 30, 43, 30, 25, 20, 37,45,26, 25, 60, 55, 40, 40, 40, 60, 27,47,27,47,39], :cell_style => { :size => 7, :padding => [5,2,5,2]}) do 
      row(0..1).font_style = :bold
      row(0..1).background_color = 'FFE34D'
      #header=[0,1]
      self.width = 790
      #0.upto(butiran_heading_rows.count-1).each do |cnt|
        #row(butiran_heading_rows[cnt]).columns(1).borders = [:top, :left, :right]
        #row(butiran_heading_rows[cnt]).columns(4..9).borders = [:top, :left, :right]
      #end
      #0.upto(butiran_not_exist.count-1).each do |cnt|
        #row(butiran_not_exist).borders =[:top, :left, :right, :bottom]
      #end
      #0.upto(butiran_exist.count-1).each do |cnt|
        #row(butiran_exist[cnt]).columns(1).borders=[:left, :right]
        #row(butiran_exist[cnt]).columns(4..9).borders=[:left, :right]
      #end
      #row(-1).background_color='FFE34D' #last row of table (in last page only)
    end
  end
  
  def line_item_rows
    counter = counter || 0
    pgcount = page_count
    header = [[{content: "BIL", rowspan: 2} ,{content: "BUT.", rowspan: 2},{content: "JAWATAN", rowspan: 2},{content: "GRED", rowspan: 2},{content: "JUM JWT", rowspan: 2}, {content: "ISI", rowspan: 2}, {content: "STATUS PENGISIAN", colspan: 3}, {content: "KSG", rowspan: 2}, {content: "NAMA PENYANDANG", rowspan: 2}, {content: "NO. K/P / PASSPORT", rowspan: 2}, {content: "JANTINA (L/P)", rowspan: 2},{content: "BIDANG KEPAKARAN/SUB-KEPAKARAN", rowspan: 2}, {content: "TARIKH WARTA PAKAR", rowspan: 2}, {content: "PENEMPATAN", rowspan: 2},{content: "PINJAM KE", colspan: 2},{content: "PINJAM DARI", colspan: 2},"CATATAN"],['HAKIKI','KONTRAK','KUP',
      'Akt.','Penempatan','Akt.','Penempatan','*']]

    datalines=[]
    @positions.each do |position|
        datalines << ["#{counter += 1}","#{position.butiran_details}","#{position.name}","#{position.try(:staffgrade).try(:name)}", "#{position.totalpost}",   "#{position.occupied_post}",   "#{position.hakiki}","#{position.kontrak}","#{position.kup}","#{position.available_post}","#{position.try(:staff).try(:name)}", "#{position.try(:staff).try(:icno)}","#{'L' if position.try(:staff).try(:gender)==1} #{'P' if position.try(:staff).try(:gender)==2}","","","","","","","",""]
        #{content: "#{position.butiran_details}", rowspan: postinfo_exist}
    end
    header+datalines
  end
end