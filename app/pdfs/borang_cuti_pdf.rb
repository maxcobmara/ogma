class Borang_cutiPdf < Prawn::Document
  def initialize(leaveforstaff, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @leaveforstaff = leaveforstaff
    @view = view
    @college=college
    
    if college.code=="kskbjb"
      font "Times-Roman"
      text "#{college.name.upcase}", :align => :center, :size => 14, :style => :bold
      move_down 5
      text "PERMOHONAN CUTI REHAT", :align => :center, :size => 14, :style => :bold
      move_down 20
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
    data=[[{content: "Kepada : <u>#{@leaveforstaff.applicant.staff_with_rank}</u>", colspan: 3}], [{content: "Saya memohon kebenaran cuti rehat selama 2 hari mulai<u> #{@leaveforstaff.leavestartdate.strftime('%d-%m-%Y')}</u> dan <u>#{@leaveforstaff.leavenddate.strftime('%d-%m-%Y')}</u>", colspan: 3}],
          ["(i) Semasa saya bercuti #{@leaveforstaff.replacement_id.nil? ? '' : '<u>'+@leaveforstaff.replacement.staff_with_rank+'</u>'}", 
           {content: "Tandatangan Pemohon : _____________________", colspan:2}],
          ["akan menjalankan tugas saya.", "Nama Penuh ", ": #{@leaveforstaff.applicant.staff_with_rank}"],
          ["(ii) Alamat dan No.Telefon saya semasa bercuti adalah seperti berikut : ", "Jawatan ", ": #{@leaveforstaff.applicant.position_for_staff}"], 
          ["#{@leaveforstaff.address_on_leave}", "Tarikh",": #{@leaveforstaff.requestdate.try(:strftime, '%d-%m-%Y')} "], 
          [{content: "Tel : #{@leaveforstaff.phone_on_leave.nil? ? @leaveforstaff.applicant.cooftelno : @leaveforstaff.phone_on_leave}", colspan: 3}]]
    table(data, :column_widths => [250, 110, 150], :cell_style => { :size => 10, :inline_format => :true,  :borders=>[]}) do
      row(1).height=40
      row(5).height=50
      row(6).borders=[:bottom]
    end
  end
  
  def table_approver
    data=[[{content: "Kepada : <u>#{@leaveforstaff.approver.staff_with_rank if !@leaveforstaff.approval2_id.blank?}</u>", colspan: 2}], 
          [{content: "(Pegawai Yang Meluluskan Cuti)", colspan: 2}], 
          ["Permohonan cuti di atas <b> #{'Disokong' if @college.code=='kskbjb' && @leaveforstaff.approval1?}#{'Tidak Disokong' if @college.code=='kskbjb' && !@leaveforstaff.approval1?}#{'Disokong' if @college.code!='kskbjb' && @leaveforstaff.approval1? && !@leaveforstaff.approval1_id.blank?}#{'Tidak Disokong' if @college.code!='kskbjb' && !@leaveforstaff.approval1?}#{'Tidak diperlukan' if  @college.code!='kskbjb' && @leaveforstaff.approval1? && @leaveforstaff.approval1_id.blank?}</b>", ""],
          ["Tarikh : #{@leaveforstaff.approval1? ? @leaveforstaff.approval1date.strftime('%d-%m-%Y') : '-'}", "_________________________________"],["", "Tandatangan Ketua Bahagian / Unit"],
          ["Permohonan cuti di atas <b> #{@leaveforstaff.approver2? ? 'Diluluskan' : 'Tidak Diluluskan'}</b>", ""],
          ["Tarikh : #{@leaveforstaff.approver2? ? @leaveforstaff.approval2date.strftime('%d-%m-%Y') : '-'}", "_________________________________"], ["", "Tandatangan Pegawai Yang <br>Meluluskan Cuti"]
          ]
    table(data, :column_widths => [300, 210], :cell_style => { :size => 10, :inline_format => :true,  :borders=>[], :padding => [5,0,0,0]}) do
      row(0).height=25
      row(0).style :valign => :bottom
      row(2).height=30
      row(2).style :valign => :bottom
      row(3).column(1).style :align => :center
      row(4).style :align => :center
      row(5).height=30
      row(5).style :valign => :bottom
      row(6).column(1).style :align => :center
      row(7).height=40
      row(7).style :align => :center
      row(7).borders=[:bottom]
    end
  end
  
  def table_official_use
    data=[[{content: "UNTUK KEGUNAAN PEJABAT", colspan: 2}],
          [{content: "Baki cuti pemohon <u> #{@leaveforstaff.applicant.appointdt.nil? ? (t 'staff_leave.appointdt_not_exist') : @leaveforstaff.balance_after} </u> hari (Diisi dan ditandatangan ringkas sebelum borang diserahkan kepada pemohon). Pemohon diberitahu dan cuti direkod. Tindakan ini hendaklah diambil setelah cuti diluluskan.", colspan: 2}], ["Tarikh : #{Date.today.strftime('%d-%m-%Y')}", "_________________________________"],
          ["", "b.p Pegawai Pentadbiran"]
         ]
    table(data, :column_widths => [300, 210], :cell_style => { :size => 10, :inline_format => :true,  :borders=>[], :padding => [5,0,0,0]}) do
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
    data=[[{content: "Kepada : <u>#{@leaveforstaff.applicant.staff_with_rank}</u><br>(Nama Pemohon)", colspan: 2}],
          [{content: "Permohonan cuti tuan/puan telah diluluskan selama <u> #{@leaveforstaff.try(:leave_for)} </u> hari dari #{@leaveforstaff.leavestartdate.strftime('%d-%m-%Y')} hingga #{@leaveforstaff.leavenddate.strftime('%d-%m-%Y')}.<br>Baki cuti rehat <u> #{ @leaveforstaff.applicant.appointdt.nil? ? (t 'staff_leave.appointdt_not_exist') : @leaveforstaff.balance_after} </u> hari.", colspan: 2}], ["Tarikh :   #{Date.today.strftime('%d-%m-%Y')}", "_________________________________"],
          ["", "b.p Pegawai Pentadbiran"]
         ]
    table(data, :column_widths => [300, 210], :cell_style => { :size => 10, :inline_format => :true,  :borders=>[], :padding => [5,0,0,0]}) do
      row(0).height=40
      row(2).height=30
      row(2).style :valign => :bottom
      row(3).column(1).style :align => :center
      row(3).height=30
      row(3).borders=[:bottom]
    end
  end
  
end