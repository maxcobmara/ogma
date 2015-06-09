class Training_reportPdf < Prawn::Document
  def initialize(ptdos, domestic, overseas, staffid, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :landscape })
    @ptdos = ptdos
    @ptdos_domestic = domestic
    @ptdos_overseas = overseas
    @staffid = staffid
    @view = view
    font "Times-Roman"
    move_down 20
    text "REKOD PENGESAHAN", :align => :center, :size => 12, :style => :bold
    text "KEHADIRAN PROGRAM LATIHAN", :align => :center, :size => 12, :style => :bold
    move_down 20
    record
    move_down 20
    signatory
    text "*Sila ceraikan helaian ini untuk dikepilkan pada buku perkhidmatan pegawai", :align => :center, :size => 9
  end
  
  def record
    table(line_item_rows, :column_widths => [30,500,200], :cell_style => { :size => 10,  :inline_format => :true}) do
      row(0).font_style = :bold
      row(0).background_color = 'FFE34D'
      row(0).align =:center
      row(8).align =:center
      row(8).font_style =:bold
      columns(0).align =:center
      columns(2).align =:center
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 730
      header = true
    end
  end
  
  def line_item_rows
    classifications=[]
    counter = counter || 0
    header = [[ 'Bil', 'Program Latihan', 'Bilangan Hari']]
    content_line =[]
    classifications=DropDown::PROGRAMME_CLASSIFICATION2
    ptdo_class=@ptdos.group_by{|x|x.ptschedule.course.training_classification}
    0.upto(classifications.count-1).each do |x|
      if classifications[x][1]==1
        content_line << [{content: "#{counter += 1}", rowspan: 3}, "#{classifications[x][0]}",""] 
        #content_line << [{content: "#{counter += 1}", rowspan: 3}, "#{classifications[x][0]}","#{Ptdo.staff_total_days(ptdo_class[1].map(&:id))}"] 
        content_line << ["a) Dalam Negeri", "#{Ptdo.staff_total_days(@ptdos_domestic.map(&:id)) unless (@ptdos_domestic.map(&:id)).count==0 }"]
        content_line << ["b) Luar Negara", "#{Ptdo.staff_total_days(@ptdos_overseas.map(&:id)) unless (@ptdos_overseas.map(&:id)).count==0 }"]
      else
        content_line << ["#{counter+=1}", "#{classifications[x][0]}","#{Ptdo.staff_total_days(ptdo_class[x+1].map(&:id)) unless (ptdo_class[x+1]).nil? }"]  #name
      end
    end
    schedule_ids = @ptdos.map(&:ptschedule_id)
    schedules_start = Ptschedule.where(id: schedule_ids).pluck(:start)
    @schedules_year=[]
    schedules_start.each do |start|
      @schedules_year << start.year
    end
    if @schedules_year.uniq.count==1
      b=Mycpd.where(staff_id: @staffid, cpd_year: Date.today.beginning_of_year).first.try(:cpd_value) 
    else
      b=I18n.t('staff.training.mycpd.same_year')
    end
	    
    content_line << ["#{counter += 1}", "Lain-lain (myCPD) - jumlah mata kumulatif", "#{b}"]
    content_line << [{content: "Jumlah Keseluruhan", colspan: 2},"#{Ptdo.staff_total_days(@ptdos.map(&:id))}"]
    header+content_line
  end
  
  def signatory
    table(line_signatory_rows, :column_widths=>[730], :cell_style => {:size=>10, :inline_format => :true}) do
      rows(0..9).borders = []
      rows(0..2).height = 20
      rows(3).height = 20
      rows(4..8).height = 20
    end
  end
  
  def line_signatory_rows
    @startdates=[]
    @ptdos.each do |ptdo|
      @startdates << ptdo.ptschedule.start.year
    end
    aa=I18n.t('staff.training.mycpd.same_year2')
    aa=@ptdos[0].ptschedule.start.year.to_s if @startdates.uniq.count==1
    [["Adalah disahkan bahawa #{'<u>'+'     '+Staff.find(@staffid).name+'    '+'</u>'}    No K/P : #{'<u>'+Staff.find(@staffid).formatted_mykad+'</u>'}"],
     ["Gred Jawatan : #{'<u>'+Staff.find(@staffid).staffgrade.name+'</u>'}    Bahagian : #{'<u>'+Staff.find(@staffid).try(:positions).try(:first).try(:unit).to_s+'</u>'}"],
     ["Telah menghadiri #{'<u>'+Ptdo.staff_total_days(@ptdos.map(&:id))+'</u>'}  hari berkursus pada tahun   #{'<u> '+aa+' </u>'}"],
     [""],
     ["(....................................................................)"],
     ["Nama Pegawai Pengesah Latihan :"],
     ["Jawatan                                         :"],
     ["Cop Pengesahan                          :"],
     ["Tarikh                                            :"]]
  end
  
end