class Status_movementPdf< Prawn::Document
  def initialize(travel_request, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @travel_request = travel_request
    @view = view
    font "Times-Roman"
    table_title
    text "(Borang ini hendaklah diisi dalam 3 salinan sebelum perjalanan dilakukan)", :style => :italic, :align => :center
    move_down 5
    table_applicant
    table_content
    table_transport_choice
    table_signatory
  end
  
  def table_title
    data = [["<u><b>BORANG PERMOHONAN UNTUK BERTUGAS DI LUAR IBU PEJABAT</b></u>"]]
    table(data, :cell_style=>{:size=>12, :inline_format => true}) do 
      rows(0).borders = []
      columns(0).align = :center
      self.width = 520
    end
  end
  
  def table_applicant
    data = [["NAMA PEGAWAI", {content: ":  #{@travel_request.staff_id.blank? ? '.'*140 : @travel_request.applicant.name}", colspan: 2}],
    [ "JAWATAN",  ":  #{@travel_request.staff_id.blank? ? '.'*60 : @travel_request.applicant.try(:positions).try(:first).try(:name)}", "GRED : #{@travel_request.applicant.positions.blank? ? '.'*45 : @travel_request.applicant.grade_for_staff}"],
    ["BAHAGIAN / UNIT", {content: ":  #{@travel_request.applicant.positions.blank? ? '.'*145 : @travel_request.applicant.positions.first.try(:unit)}", colspan: 2}],
    [{content: "TUGAS-TUGAS YANG AKAN DIJALANKAN, TEMPAT DAN TEMPOH BERTUGAS :", colspan: 3}]      ]
          
    table(data, :column_widths => [110,200,210], :cell_style => { :size => 11}) do
      columns(0).borders = []
      columns(1).borders = []
      columns(2).borders = []
      self.width = 520
    end
  end
  
  def table_content
    data = [["<u>TEMPAT</u>", "<u>PERIHAL</u>","<u>TEMPOH</u>"],
     [ "#{@travel_request.destination.blank? ? '.'*55 : @travel_request.destination}", "#{@travel_request.document.blank? ? '.'*55 : @travel_request.document.title[0,30]}","#{@travel_request.depart_return.blank? ? '.'*55 : @travel_request.depart_return}"],
     #[ "#{'.'*55}",  "#{'.'*55}",  "#{'.'*55}"],
     ["CARA PERJALANAN : ", {content: "", colspan: 2}]
     ]
          
    table(data, :column_widths => [173,173,174], :cell_style => { :size => 11, :inline_format => true}) do
      columns(0).borders = []
      columns(1).borders = []
      columns(2).borders = []
      rows(0).align = :center
      rows(1).align = :center
      #rows(2).align = :center
      self.width = 520
    end
  end
  
  def table_transport_choice
    data = [["","#{'<b>/</b>' if @travel_request.own_car==true}","Kereta Sendiri","#{'<b>/</b>' if @travel_request.train==true}","Keretapi","#{'<b>/</b>' if @travel_request.dept_car==true}","Kenderaan Jabatan"], ["","","","","","",""], 
    ["","#{'<b>/</b>' if @travel_request.plane==true}","Kapal Terbang","#{'<b>/</b>' if (@travel_request.taxi==true|| @travel_request.bus==true || @travel_request.train==true || @travel_request.plane==true || @travel_request.other==true)}","Kenderaan Awam","#{'<b>/</b>' if @travel_request.others_car==true}","Menumpang Pegawai Lain"], 
    ["","","",{content: "<b>Nyatakan</b>:  #{'.'*40 if(@travel_request.taxi==false&& @travel_request.bus==false&& @travel_request.train==false && @travel_request.plane==false && @travel_request.other==false)} <u>#{@travel_request.other_desc if @travel_request.other==true} #{'Teksi' if @travel_request.taxi==true} #{'Bas' if @travel_request.bus==true} #{'Keretapi' if @travel_request.train==true} #{'Kapal Terbang' if @travel_request.plane==true}</u>", colspan: 2},{content: "Pegawai Lain : #{@travel_request.others_car_notes if @travel_request.others_car==true} #{'Sila sebutkan nama & tempat bertugas pegawai ini' if @travel_request.others_car==false} ", colspan: 2}],
    ["",{content: "JIKA TIDAK MENAIKI KERETA / KAPAL TERBANG KERANA MENGGUNAKAN KERETA SENDIRI, ", colspan: 6}],
    ["",{content: "SILA NYATAKAN SEBABNYA :", colspan: 6}],
    ["",{content: "#{'.'*180 if @travel_request.own_car==false} <u>#{@travel_request.own_car_notes if @travel_request.own_car==true}</u>", colspan: 6}],["",{content: "#{'.'*180 if @travel_request.own_car==false} ", colspan: 6}],
    ["",{content: "JIKA MENGGUNAKAN KERETA SENDIRI TUNTUTAN YANG AKAN DIBUAT ADALAH : ", colspan: 6}],
    ["","#{'<b>/</b>' if @travel_request.mileage_history==1}","Elaun Hitungan Batu","","#{'<b>/</b>' if @travel_request.mileage_history==2} ",{content: "Gantian Tambang Keretapi / Kapal Terbang", colspan: 2}],
    [{content: "", colspan: 7}],
    ["",{content: "Tarikh : #{@travel_request.submitted_on.blank? ? '.'*40 : @travel_request.submitted_on.try(:strftime, '%d %b %Y')}", colspan: 2},"",{content: "T/Tangan Pemohon : #{'.'*50}", colspan: 3}],
    [{content: "<b>PERAKUAN KETUA JABATAN</b>", colspan: 7}],
    [{content: "Permohonan untuk menjalankan tugas-tugas rasmi di luar Ibu Pejabat seperti di atas adalah *diluluskan / #{'<strikethrough>tidak diluluskan</strikethrough>' if @travel_request.hod_accept == true} . Adalah disahkan pegawai in perlu menggunakan keretanya sendiri dan diperakukan bahawa beliau dibayar :", colspan: 7}],
    ["","#{'<b>/</b>' if @travel_request.mileage_replace!=nil &&  @travel_request.mileage_replace==false}","Elaun Hitungan Batu","","#{'<b>/</b>' if @travel_request.mileage_replace==true}",{content: "Gantian Tambang Keretapi / Kapal Terbang", colspan: 2}],
    ["",{content: "Tarikh : #{@travel_request.hod_accept_on.blank? ? '.'*40 : @travel_request.hod_accept_on.try(:strftime, '%d %b %Y')}", colspan: 2},"",{content: "#{'.'*80}", colspan: 3}]]

    table(data, :column_widths => [4, 86,86,86,86,86,86], :cell_style => { :size => 11, :inline_format => true}) do
      rows(0).height= 32
      rows(1).height= 14
      rows(2).height= 32
      rows(3).height= 40
      rows(3).valign= :bottom
      rows(1).borders = []
      cells[0,0].borders=[]
      cells[0,1].size= 25
      cells[0,1].align = :center
      cells[0,3].size= 25
      cells[0,3].align = :center
      cells[0,5].size= 25
      cells[0,5].align = :center
      cells[2,1].size= 25
      cells[2,1].align = :center
      cells[2,3].size= 25
      cells[2,3].align = :center
      cells[2,5].size= 25
      cells[2,5].align = :center
      cells[1,0].borders=[]
      cells[2,0].borders=[]
      cells[0,2].borders=[]
      cells[1,2].borders=[]
      cells[2,2].borders=[]
      cells[0,4].borders=[]
      cells[1,4].borders=[]
      cells[2,4].borders=[]
      cells[0,6].borders=[]
      cells[1,6].borders=[]
      cells[2,6].borders=[]
      columns(2).align = :left
      columns(4).align = :left
      columns(6).align = :left
      rows(3).borders =[]
      rows(4).borders =[]
      rows(4).height =20
      rows(5).hright =20
      rows(5).borders =[]
      rows(6).borders = []
      rows(7).borders = []
      rows(8).borders = []
      rows(8).height = 30
      cells[9,1].size=25
      cells[9,1].align=:center
      cells[9,4].size=25
      cells[9,4].align=:center
      cells[9,0].borders = []
      cells[9,2].borders = []
      cells[9,3].borders = []
      cells[9,5].borders = []
      rows(9).height=32
      rows(10).borders = []
      rows(11).borders = [:bottom]
      rows(12).align=:center      #note : row 12 -> PERAKUAN KETUA JABATAN
      rows(12).borders=[]
      rows(13).borders=[]
      rows(13).height=50
      rows(14).height=32
      cells[14,1].size=25
      cells[14,1].align=:center
      cells[14,4].size=25
      cells[14,4].align=:center
      cells[14,0].borders=[]
      cells[14,2].borders=[]
      cells[14,3].borders=[]
      cells[14,5].borders=[]
      cells[15,1].align=:left
      cells[15,3].align=:center
      rows(15).valign=:bottom
      rows(15).height=30
      rows(15).borders=[]
      self.width = 520
    end
  end
  
  def table_signatory
    data = [["","","Tandatangan Ketua Jabatan"],
    ["","","(Pegawai atasan yang langsung)"],
    ["","NAMA",": #{@travel_request.hod_id.blank? ? '.'*50 : @travel_request.headofdept.try(:name)}"],
    ["","JAWATAN ",": #{@travel_request.hod_id.blank? ? '.'*50 : @travel_request.headofdept.position_for_staff}"],
    ["","COP RASMI  ",": #{'.'*50}"]]
          
    table(data, :column_widths => [280,70,170], :cell_style => { :size => 11}) do
      rows(0).borders = []
      rows(1).borders = []
      rows(0).height = 20
      rows(1).height = 20
      rows(2).borders = []
      rows(3).borders = []
      rows(4).borders = []
      rows(2).height = 20
      rows(3).height = 20
      rows(4).height = 20
      columns(0).align = :right
      self.width = 520
    end
  end
  
  
  
end