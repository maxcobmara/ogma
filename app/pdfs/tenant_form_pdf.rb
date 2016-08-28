class Tenant_formPdf < Prawn::Document
  def initialize(tenant, view, current_user)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @tenant = tenant
    @view = view
    @college = current_user.college
    @staff=current_user.userable
    @page_number=page_number
    font "Helvetica"
    title_logo
    move_down 10
    table_heading
    move_down 10
    table_details
    move_down 20
    table_tenancy
    move_down 10
    table_tenancy2
    move_down 15
    footer
    start_new_page
    title_logo
    move_down 10
    table_heading
    move_down 10
    table_notes
    footer
  end
  
  def title_logo
    
    bounding_box([10,780], :width => 400, :height => 100) do |y2|
       image "#{Rails.root}/app/assets/images/logo_kerajaan.png",  :width =>97.2, :height =>77.76
    end
    bounding_box([150,760], :width => 350, :height => 100) do |y2|
      if @college.code=="kskbjb"
        move_down 30
        text "#{@college.name}"
        move_down 1
        text "#{I18n.t('student.tenant.title')}"
      elsif @college.code="amsas"
        draw_text "PPL APMM", :at => [80, 85], :style => :bold
        draw_text "NO.DOKUMEN: BK-LAT-KS-02-02", :at => [15, 60], :style => :bold
        draw_text "BORANG KEDIAMAN ASRAMA", :at => [20, 45], :style => :bold
      end
    end
    
    if @college.code=="kskbjb"
      bounding_box([400,760], :width => 400, :height => 100) do |y2|
        image "#{Rails.root}/app/assets/images/kskb_logo-6.png",  :width =>97.2, :height =>77.76
      end
    elsif @college.code="amsas"
      bounding_box([430,780], :width => 400, :height => 90) do |y2|
        image "#{Rails.root}/app/assets/images/amsas_logo_small.png"
      end
    end
  end
  def table_heading
    data=[["#{I18n.t('exam.evaluate_course.prepared_by')} : #{@tenant.location.staffadmin_id? ? @tenant.location.administrator.try(:staff_with_rank) : '<br><br>'}", "#{I18n.t('exam.evaluate_course.date_updated')} : #{@tenant.updated_at.try(:strftime, '%d-%m-%Y')} "],["",""]]
    if @page_number==1
      data <<  [{content: "<u>BORANG KEDIAMAN ASRAMA</u>", colspan: 2}]
    else
      data << ["",""]
    end
    table(data, :column_widths => [255,255], :cell_style => {:inline_format => true, :size=>11, :borders => [:left, :right, :top, :bottom]}) do
      column(0).font_style = :bold
      column(1).font_style = :bold
      row(1..2).borders=[]
      row(1).height=10
      row(2).column(0).align = :center
    end
  end
  
  def table_details
    data =[[{content: "A. MAKLUMAT PELATIH", colspan: 2}],
          [{content: "Nama Pelatih : #{@tenant.student.try(:name)}", colspan: 2}],
          [{content: "No. K/P : #{@tenant.student.try(:formatted_mykad)}", colspan: 2}],
          ["Pangkat : #{@tenant.student.student_with_rank}", "Jawatan : #{@tenant.student.try(:position)}"],
          [{content: "Unit/Bahagian/Cawangan : #{@tenant.student.try(:department)}", colspan: 2}],
          [{content: "Nama Kursus : #{@tenant.student.course.programme_list}", colspan: 2}],
          [{content: "Tarikh Mula Kursus : #{@tenant.student.intake_id? ? @tenant.student.intakestudent.register_on.try(:strftime, '%d-%m-%Y') : @tenant.student.intakestudent.try(:strftime, '%d-%m-%Y')}", colspan: 2}],
          [{content: "Tarikh Tamat Kursus : #{@tenant.student.end_training.try(:strftime, '%d-%m-%Y')}", colspan: 2}],
          [{content: "Alamat Rumah : #{@tenant.student.address}", colspan: 2}],
          [{content: " No. Telefon Bimbit : #{@tenant.student.stelno}", colspan: 2}],
          ["No. Kenderaan : #{@tenant.student.try(:vehicle_no)}", "Jenis Kenderaan : #{@tenant.student.try(:vehicle_type)}"]]
          
    table(data, :column_widths => [255, 255], :cell_style => { :size => 11, :padding => [5,0,0,5]})  do
      a = 0
      b = 25
      row(0..10).height=22
      row(0).font_style = :bold
      row(0).background_color = 'FFE34D'
    end
  end
  #   {content: " :", colspan: 2}
  ##{'<b>A </b>/ B / C / D / E' if @travel_claim.transport_class == 'A'}
  def table_tenancy
    data = [[{content: "B. PENEMPATAN ASRAMA", colspan: 2}],
           ["Asrama : #{'<b>Asas Lelaki</b> / Wanita / Pegawai' if @tenant.location.root.code=='AA'}#{'Asas Lelaki / <b>Wanita</b> / Pegawai' if @tenant.location.root.code=='AW'} #{'Asas Lelaki / Wanita / <b>Pegawai</b>' if @tenant.location.root.code=='AL'}", " Bilik No : #{@tenant.location.combo_code}"], 
           [{content: "Bilangan Kunci Diberikan : #{@tenant.total_keys}", colspan: 2}], 
           [{content: "Deposit Dikenakan :  <u>#{@view.ringgols(@tenant.deposit)}                </u>  Catatan Dalam Buku Kediaman : Ada / Tiada ", colspan: 2}], 
           ["Keperluan Sajian : "," Ya                      Tidak    "]] 
        
    table(data, :column_widths => [215, 300], :cell_style => {:inline_format => true, :size => 11, :padding => [5,0,0,5]})  do
      a = 0
      b = 5
      row(0).font_style = :bold
      row(0).background_color = 'FFE34D'
      row(1).column(0).borders=[:left]
      row(1).column(1).borders=[:right]
      row(4).column(0).borders=[:left, :bottom]
      row(4).column(1).borders=[:right, :bottom]
      row(0..3).height=25
      row(4).height=35
    end
    
    #boxes for Keperluan Sajian
    bounding_box([240,210], :width => 100, :height => 10) do |y2|
      if @tenant.meal_requirement==true
        draw_text "/", :at => [26, 20]
      elsif @tenant.meal_requirement==false
        draw_text "/", :at => [115, 20]
      end
      stroke do
	horizontal_line 10, 48, :at => 35
        horizontal_line 10, 48, :at => 15
	horizontal_line 100, 138, :at => 35
        horizontal_line 100, 138, :at => 15
	vertical_line 15, 35, :at => 10
	vertical_line 15, 35, :at => 48
	vertical_line 15, 35, :at => 100
	vertical_line 15, 35, :at => 138
      end
    end
  end
  
  def table_tenancy2
    data=[[{content: "B. PENEMPATAN ASRAMA", colspan: 2}], 
          ["5. <u>Oleh Pelatih</u>", "<u>Oleh : KULA / BLA / JL</u>"],
          ["Nama Pelatih : ", "Nama Pelatih : "],
          ["Tandatangan : ", "Tandatangan : "],
          ["Tarikh : #{@tenant.updated_at.try(:strftime, '%d-%m-%Y')}", "Tarikh : #{@tenant.updated_at.try(:strftime, '%d-%m-%Y')}"],["",""]]
    table(data, :column_widths => [255, 255], :cell_style => {:inline_format => true, :size => 11, :padding => [5,0,0,5]})  do
      a = 0
      b = 5
      row(0).font_style = :bold
      row(0).background_color = 'FFE34D'
      row(1).borders=[:left]
      row(1).column(1).align=:center
      row(2..4).borders=[:bottom]
      column(0).row(1).borders=[:left]
      column(1).row(1).borders=[:right]
      column(0).rows(2..4).borders=[:left]
      column(1).rows(2..4).borders=[:right]
      column(0).row(5).borders=[:left, :bottom]
      column(1).row(5).borders=[:right, :bottom]
      row(0).height=25
      row(1).height=25
      row(2).height=35
      row(3).height=50
      row(4).height=35
    end
    #underlines 
    bounding_box([5,125], :width => 500, :height => 100) do |y2|
      stroke do
	horizontal_line 0, 210, :at => 80
	horizontal_line 255, 470, :at => 80
	horizontal_line 0, 210, :at => 30
	horizontal_line 255, 470, :at => 30
        horizontal_line 0, 210, :at => 0
	horizontal_line 255, 470, :at => 0
      end
    end
  end
  
  def footer
    draw_text "BK-LAT-KS-02-02", :size => 8, :at => [0,0]
    draw_text "#{page_number} daripada 2",  :size => 8, :at => [460,0]
  end
  
  def table_notes
   
    data=[["Nota :"],["1. Deposit akan dikembalikan apabila pelatih selesai menjalani kursus."], ["2. Kenderaan hanya dibenarkan hanya untuk peserta kursus lanjutan/undang-undang sahaja."]]
    table(data, :column_widths => [510], :cell_style => {:inline_format => true, :size=>11}) do
      row(0).font_style = :bold
      row(0).borders=[:left, :right, :top]
      row(1).borders=[:left, :right]
      row(2).borders=[:left, :right, :bottom]
      row(0..2).height=30
    end
 
  end
         
end