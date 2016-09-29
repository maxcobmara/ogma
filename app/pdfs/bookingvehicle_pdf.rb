class BookingvehiclePdf < Prawn::Document  
  def initialize(asset_loan, view, college)
    super({top_margin: 40, page_size: 'A4', page_layout: :portrait })
    @asset_loan = asset_loan
    @view = view
    font "Helvetica"
    if college.code=="kskbjb"
      move_down 10
    end
    bounding_box([10,770], :width => 400, :height => 100) do |y2|
       image "#{Rails.root}/app/assets/images/logo_kerajaan.png",  :width =>97.2, :height =>77.76
    end
    bounding_box([90,760], :width => 350, :height => 100) do |y2|
      if college.code=="kskbjb"
        move_down 30
        text "#{college.name}"
        move_down 1
        text "PINJAMAN / PENGGUNAAN KENDERAAN", :style => :bold, :align => :center
      else
        text "PPL APMM", :style => :bold, :align => :center
	move_down 10
	text "#{I18n.t('instructor_appraisal.document_no').upcase}: BK-LAT-TBL-05-01", :style => :bold, :align => :center
	text "PINJAMAN / PENGGUNAAN KENDERAAN", :style => :bold, :align => :center
      end
    end
    
    if college.code=="kskbjb"
      bounding_box([400,750], :width => 400, :height => 100) do |y2|
        image "#{Rails.root}/app/assets/images/kskb_logo-6.png",  :width =>97.2, :height =>77.76
      end
    else
      bounding_box([430,770], :width => 400, :height => 90) do |y2|
        image "#{Rails.root}/app/assets/images/amsas_logo_small.png"
      end
    end
    table_main
    #move_down 10
    table_vehicle
    move_down 10
    table_approved_signatory
    move_down 3
    table_ending
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  def table_main
    #:padding=>[2,5,3,5] #tlbr
    data=[[{content: "PEMOHON", colspan: 4}], 
          ["", {content: "Nama : #{@asset_loan.staff.staff_with_rank}", colspan: 2}, "No KP : #{@view.formatted_mykad(@asset_loan.staff.icno)}"],
          ["", {content: "Jawatan : #{@asset_loan.staff.position_for_staff}", colspan: 2}, "No Telefon : #{@asset_loan.staff.cooftelno}"],
          ["", {content: "Tarikh Digunakan : #{@asset_loan.loaned_on.strftime('%d/%m/%Y')}", colspan: 2}, "Tarikh Dipulangkan : #{@asset_loan.is_returned? ? @asset_loan.returned_on.strftime('%d/%m/%Y') : @asset_loan.expected_on.strftime('%d/%m/%Y')}"],
          ["", {content: "Tujuan/Lokasi : #{@asset_loan.reasons}", colspan: 3}],
          ["", {content: "Nama Pemandu : #{@asset_loan.driver.staff_with_rank}", colspan: 3}],
          ["", {content: "Dengan ini saya mengakui dan mematuhi syarat-syarat berikut :", colspan: 3}],
          ["", "i.", {content: "Merekod Pergerakan Kenderaan di dalam KEW PA 6.", colspan: 2}],
          ["", "ii.", {content: "Merekod Pengeluaran Kad Inden di dalam Buku Daftar Penggunaan Kad Inden.", colspan: 2}],
          ["", "iii.", {content: "Merekod Pengeluaran Kad Touch N Go (No....) di dalam Buku Daftar Kad Touch N Go (Sekiranya perlu).", colspan: 2}],
          ["", "iv.", {content: "Merekod Penggunaan Kenderaan di dalam Buku Log Kenderaan.", colspan: 2}],
          ["", "v.", {content: "Kepilkan resit di dalam Buku Log Kenderaan dan catatkan di ruangan pembelian bahanapi.", colspan: 2}],
          ["", "vi.", {content: "Melaporkan kerosakan/kehilangan kenderaan kepada Penyelia Kenderaan/ Ketua Tadbir Bantuan dan Operasi Latihan dengan segera.", colspan: 2}],
          ["", "vii.", {content: "Sentiasa mematuhi undang-undang jalan raya.", colspan: 2}],
          ["",{content: "Tarikh : #{@asset_loan.created_at.strftime('%d/%m/%Y')}", colspan: 2}, "Tandatangan : T.T"],
          [{content: "PENYELIA KENDERAAN", colspan: 4}],
          ["", {content: "Permohonan #{@asset_loan.is_endorsed? ? '<b><u>disokong</u></b> / tidak disokong' : 'disokong / <b><u>tidak disokong</u></b>' }", colspan: 3}],
          ["", {content: "Catatan : #{@asset_loan.endorsed_note}", colspan: 3}],
          ["", {content: "Tarikh : #{@asset_loan.endorsed_date.try(:strftime, '%d/%m/%Y')}", colspan: 2}, "Tandatangan : T.T"],
          [{content: "KETUA TADBIR BANTUAN DAN OPERASI LATIHAN", colspan: 4}],
          ["", {content: "Catatan : #{@asset_loan.approved_note}", colspan: 3}],
          ["", {content: "Permohonan anda #{@asset_loan.is_approved? ? '<b><u>diluluskan</u></b> / tidak diluluskan' : 'diluluskan / <b><u>tidak diluluskan</u></b>'}", colspan: 3}],
          ["","","",""]]
    
    table(data, :column_widths => [10, 20, 270, 210], :cell_style => {:size=>10, :borders => [:left, :right, :top, :bottom],  :inline_format => :true, :padding=>[3,5,3,2]}) do
        row(0).background_color="D9D9D9"
        row(0).font_style=:bold
        row(0).style :align => :center
	row(1).height=25
	row(1).style :valign => :bottom
	row(6).height=25
	row(7..13).column(1).style :align => :right
 	row(13).height=30#13-14
	row(15).background_color="D9D9D9"
        row(15).font_style=:bold
        row(15).style :align => :center
	row(16..18).borders=[]
	row(17).height=30#17-18
	row(19).background_color="D9D9D9"
        row(19).font_style=:bold
        row(19).style :align => :center
	row(20).height=30
	row(20..22).borders=[]
	row(1..14).borders=[]
    end  
  end
  
  def table_vehicle
     #:padding=>[2,5,3,5] #tlbr
    
    @vehicles=Asset.joins(:category).where('category_id=? or description=?', 3, 'Kenderaan')
    data=[["","","","","","","","","","","",""],["Bil",{content: "Jenis Kenderaan", colspan: 11}]]
    count=0
    @vehicles.in_groups_of(4).each_with_index do |row_group, row_no|
      per_row=[]
      row_group.each_with_index do |vehicle, col_no|
        if vehicle
          typename=vehicle.try(:typename).gsub("Spanco", "")
	  if @asset_loan.asset_id==vehicle.id 
	    check_val="<b>/<b>"
	  else
	    check_val=""
	  end
	else
	  typename=""
	  check_val=""
	end
        per_row+=[(row_no+col_no*4)+1, "#{vehicle.try(:subcategory)} #{typename}<br>#{vehicle.try(:registration)}", check_val]
      end
      data << per_row
    end
    
    table(data, :column_widths => [20, 90, 20, 20, 90, 15, 20, 90, 15, 20, 90, 15], :cell_style => {:size=>10, :borders => [:left, :right, :top, :bottom],  :inline_format => :true, :padding=>[1, 5, 5, 2]}) do
      row(0).borders=[]
      row(1).background_color="D9D9D9"
      row(1).font_style=:bold
      row(1).style :align => :center
      column(2).style :align => :center
      column(2).font_style =:bold
      column(5).style :align => :center
      column(5).font_style =:bold
      column(8).style :align => :center
      column(8).font_style =:bold
      column(11).style :align => :center
      column(11).font_style =:bold
    end
  end
  
  def table_approved_signatory
    data=[["Tarikh : #{@asset_loan.approved_date.try(:strftime, '%d-%m-%Y')}","Tandatangan : T.T"]]
    table(data, :column_widths => [300,210], :cell_style => {:size=>10, :borders => [:left, :right, :top, :bottom]}) do
      row(0).borders=[]
    end
  end
  
  def table_ending
    data=[["DISEDIAKAN OLEH : STAF TBL","#{I18n.t('exam.evaluate_course.date_updated')} : #{@asset_loan.updated_at.try(:strftime, '%d-%m-%Y')} "]]
    table(data, :column_widths => [310,200], :cell_style => {:size=>11, :borders => [:left, :right, :top, :bottom]}) do
      a = 0
      b = 1
      column(0).font_style = :bold
      column(1).font_style = :bold
      while a < b do
        a=+1
      end
    end
  end
  
  def footer
    draw_text "#{page_number} #{I18n.t('instructor_appraisal.from')} 1",  :size => 8, :at => [240,-5]
  end
  
end
