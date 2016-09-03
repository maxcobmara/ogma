class Slip_pengesahan_cuti_pelajarPdf < Prawn::Document
  def initialize(leaveforstudent, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @leaveforstudent = leaveforstudent
    @view = view
    @college=college
    
    if college.code=="kskbjb"
      font "Times-Roman"
      text "#{college.name.upcase}", :align => :center, :size => 14, :style => :bold
      move_down 5
      text "SLIP PENGESAHAN CUTI PELAJAR", :align => :center, :size => 14, :style => :bold
      move_down 20
      table1
      
      if @leaveforstudent.student.kins.count > 0
	table2
      end
      table3
    elsif college.code=="amsas"
      font "Helvetica"
      draw_text "Surat Pekeliling Am Bil.3 Tahun 1991", :at => [390, 770], :size => 8
      text "PERMOHONAN CUTI REHAT", :align => :center, :size => 12, :style => :bold
      move_down 20
      table_applicant
      table_approver
      table_official_use
      table_reply_applicant
    end
  end
  
  def table_applicant
    data=[[{content: "Kepada : <u>#{@leaveforstudent.staff.try(:staff_with_rank)}</u>", colspan: 3}], [{content: "Saya memohon kebenaran cuti rehat selama 2 hari mulai<u> #{@leaveforstudent.leave_startdate.strftime('%d-%m-%Y')}</u> dan <u>#{@leaveforstudent.leave_enddate.strftime('%d-%m-%Y')}</u>", colspan: 3}],
          ["(i) Semasa saya bercuti __________________", {content: "Tandatangan Pemohon : _____________________", colspan:2}],
          ["akan menjalankan tugas saya.", "Nama Penuh ", ": #{@leaveforstudent.student.student_with_rank}"],
          ["(ii) Alamat dan No.Telefon saya semasa bercuti adalah seperti berikut : ", "Jawatan ", ": Pelatih"], 
          ["#{@leaveforstudent.address}", "Tarikh",": #{@leaveforstudent.requestdate.try(:strftime, '%d-%m-%Y')} "], [{content: "Tel : #{@leaveforstudent.telno}", colspan: 3}]]
    table(data, :column_widths => [250, 110, 150], :cell_style => { :size => 11, :inline_format => :true,  :borders=>[]}) do
      row(1).height=40
      row(5).height=50
      row(6).borders=[:bottom]
    end
  end
  
  def table_approver
    data=[[{content: "Kepada : <u>#{@leaveforstudent.staff.try(:staff_with_rank)}</u>", colspan: 2}], 
          [{content: "(Pegawai Yang Meluluskan Cuti)", colspan: 2}], 
          ["Permohonan cuti di atas - ", ""],
          ["Tarikh : - ", "_________________________________"],["", "Tandatangan Ketua Bahagian / Unit"],
          ["Permohonan cuti di atas <b> #{@leaveforstudent.approved==true ? 'Diluluskan' : 'Tidak Diluluskan'}</b>", ""],
          ["Tarikh : #{@leaveforstudent.approved==true ? @leaveforstudent.approvedate.strftime('%d-%m-%Y') : '-'}", "_________________________________"], ["", "Tandatangan Pegawai Yang <br>Meluluskan Cuti"]
          ]
    table(data, :column_widths => [300, 210], :cell_style => { :size => 11, :inline_format => :true,  :borders=>[], :padding => [5,0,0,0]}) do
      row(0).height=25
      row(0).style :valign => :bottom
      row(2).height=30
      row(2).style :valign => :bottom
      row(4).style :align => :center
      row(5).height=30
      row(5).style :valign => :bottom
      row(7).height=40
      row(7).style :align => :center
      row(7).borders=[:bottom]
    end
  end
  
  def table_official_use
    data=[[{content: "UNTUK KEGUNAAN PEJABAT", colspan: 2}],
          [{content: "Baki cuti pemohon _______ hari (Diisi dan ditandatangan ringkas sebelum borang diserahkan kepada pemohon). Pemohon diberitahu dan cuti direkod. Tindakan ini hendaklah diambil setelah cuti diluluskan.", colspan: 2}], ["Tarikh : ", "_________________________________"],
          ["", "b.p Pegawai Pentadbiran"]
         ]
    table(data, :column_widths => [300, 210], :cell_style => { :size => 11, :inline_format => :true,  :borders=>[], :padding => [5,0,0,0]}) do
      row(0).style :align => :center
      row(0).font_style =:bold
      row(0).height=30
      row(2).height=50
      row(2).style :valign => :bottom
      row(3).column(1).style :align => :center
      row(3).height=30
      row(3).borders=[:bottom]
    end
  end
  
  def table_reply_applicant
    data=[[{content: "Kepada : <u>#{@leaveforstudent.student.student_with_rank}</u><br>(Nama Pemohon)", colspan: 2}],
          [{content: "Permohonan cuti tuan/puan telah diluluskan selama 2 hari dari #{@leaveforstudent.leave_startdate.strftime('%d-%m-%Y')} hingga #{@leaveforstudent.leave_enddate.strftime('%d-%m-%Y')}.<br>Baki cuti rehat _____ hari.", colspan: 2}], ["Tarikh : ", "_________________________________"],
          ["", "b.p Pegawai Pentadbiran"]
         ]
    table(data, :column_widths => [300, 210], :cell_style => { :size => 11, :inline_format => :true,  :borders=>[], :padding => [5,0,0,0]}) do
      row(0).height=40
      row(2).height=30
      row(2).style :valign => :bottom
      row(3).column(1).style :align => :center
      row(3).height=30
      row(3).borders=[:bottom]
    end
  end
  
  def table1
    
    data =[["Butiran Cuti Pelajar", ""],
          ["1. Nama Pelajar", ": #{@college.code=="amsas" ? @leaveforstudent.student.student_with_rank :  @leaveforstudent.student.formatted_mykad_and_student_name}"],
          ["2. Jenis Cuti", ": #{((DropDown::STUDENTLEAVETYPE2.find_all{|disp, value| value == @leaveforstudent.leavetype }).map {|disp, value| disp})[0]}"],
          ["3. Tarikh Mohon Cuti", ": #{I18n.l(@leaveforstudent.requestdate)}"],
          ["4. Sebab", ": #{@leaveforstudent.reason}"],
          ["5. Alamat",": #{@leaveforstudent.address}"],
          ["6. Telefon", ": #{@leaveforstudent.telno }"],
          ["7. Tarikh Cuti Bermula", ": #{ I18n.l(@leaveforstudent.leave_startdate, format: :full_events)}"],
          ["8. Tarikh Cuti Berakhir", ": #{ I18n.l(@leaveforstudent.leave_enddate, format: :full_events)}"]]
    
    table(data, :column_widths => [200, 300], :cell_style => { :size => 11})  do
      a = 0
      b = 25
      row(0).font_style = :bold
      row(0).background_color = 'FFE34D'
      while a < b do
        row(a).borders = []
        a += 1
      end
    end
    move_down 10
  end
    
  def table2
    
    data =[["Maklumat Waris", ""]]      
      
    table(data, :column_widths => [200, 300], :cell_style => { :size => 11})  do
      a = 0
      b = 1
      row(0).font_style = :bold
      row(0).background_color = 'FFE34D'
      while a < b do
        row(a).borders = []
        a += 1
      end
    end
            
    @a = []
    @b = []
    @c = []       
                            
    @leaveforstudent.student.kins.map do |x|
      @a << ": #{x.name} "
      @b << ": #{x.display_ktype} "
      @c << ": #{x.phone} "
    end
             
    data2=[]        
    0.upto(@leaveforstudent.student.kins.count-1) do |no|
      data2 << ["Nama","#{@a[no]}"]
      data2 << ["Hubungan","#{@b[no]}"]
      data2 << ["No. Telefon","#{@c[no]}"]
      data2 << ["",""]
    end
    
    table(data2, :column_widths => [200, 300], :cell_style => { :size => 10}) do
      a = 0
      b = data2.size
      while a < b do
        row(a).borders = []
        a += 1
      end
    end
    move_down 10
  end

  def table3
    
    if @college.code=="kskbjb"  
      data =[["Maklumat Kelulusan Cuti", ""],
            ["1. Keputusan Penyelaras Kumpulan", ": #{@leaveforstudent.approved? ? 'Diluluskan' : 'Tidak Diluluskan'}"],
            ["2. Nama Pelulus", ": #{@leaveforstudent.approver_details}"],
            ["3. Tarikh Diluluskan", ": #{@leaveforstudent.approved? ? I18n.l(@leaveforstudent.approvedate) : @leaveforstudent.approvedate.try(:strftime, '%d %b %Y')}"],
            ["",""],
            ["4. Keputusan Warden", ": #{@leaveforstudent.approved2? ? 'Diluluskan' : 'Tidak Diluluskan'}"],
            ["5. Nama Pelulus", ": #{@leaveforstudent.approver_details2}"],
            ["6. Tarikh Diluluskan", ": #{@leaveforstudent.approved? ? (@leaveforstudent.approvedate2.try(:strftime, '%d %b %Y')) : @leaveforstudent.approvedate2.try(:strftime, '%d %b %Y')}"]]
    else
      data =[["Maklumat Kelulusan Cuti", ""],
            ["1. Keputusan Permohonan", ": #{@leaveforstudent.approved? ? 'Diluluskan' : 'Tidak Diluluskan'}"],
            ["2. Nama Pelulus", ": #{@leaveforstudent.approver_details}"],
            ["3. Tarikh Diluluskan", ": #{@leaveforstudent.approved? ? I18n.l(@leaveforstudent.approvedate) : @leaveforstudent.approvedate.try(:strftime, '%d %b %Y')}"]]
    end
  
    table(data, :column_widths => [200, 300], :cell_style => { :size => 11})  do
      a = 0
      b = 23
      row(0).font_style = :bold
      row(0).background_color = 'FFE34D'
      while a < b do
        row(a).borders = []
        a += 1
      end
    end
    move_down 10
  end
end