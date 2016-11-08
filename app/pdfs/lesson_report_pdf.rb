class Lesson_reportPdf< Prawn::Document
  def initialize(lesson_plan, view, college)
    super({top_margin: 10, page_size: 'A4', page_layout: :portrait })
    @lesson_plan = lesson_plan
    @view = view
    @college=college
    font "Times-Roman"
    if college.code=="kskbjb"
      text "BPL.KKM.PK(T04D/09)", :align => :right, :size => 9
    else
      move_down 5
    end
    move_down 40
    image "#{Rails.root}/app/assets/images/logo_kerajaan.png", :position => :center, :scale => 0.55
    move_down 20
    if college.code=="kskbjb"
      text "KEMENTERIAN KESIHATAN MALAYSIA", :style => :bold, :align => :center
    else
      text "#{college.name.upcase}", :style => :bold, :align => :center
    end
    move_down 5
    text "LAPORAN AKTIVITI PENGAJARAN DAN PEMBELAJARAN", :align => :center, :size => 11
    move_down 25
    table_teaching_method
    move_down 15
    table_plan
    move_down 15
    table_report
    move_down 15
    table_signatory
  end
  
  def table_teaching_method
    data = [["", "#{'<b>/</b>' if @lesson_plan.schedule_item.lecture_method == 1}","Kuliah","#{'<b>/</b>' if @lesson_plan.schedule_item.lecture_method == 2}","Tutorial","#{'<b>/</b>' if @lesson_plan.schedule_item.lecture_method == 3}","Amali"]]
          
    table(data, :column_widths => [100,50,70,50,70,50,70], :cell_style => { :size => 11, :align=> :center,  :inline_format => true}) do
      columns(0).borders = []
      columns(1).borders = [:top, :right, :left, :bottom]
      columns(2).borders = []
      columns(3).borders = [:top, :right, :left, :bottom]
      columns(4).borders = []
      columns(5).borders = [:top, :right, :left, :bottom]
      columns(6).borders = []
      self.width = 460
    end
  end
  
  def table_plan
    data = [["","Nama Pengajar",":","#{@lesson_plan.lessonplan_owner.rank_id? ? @lesson_plan.lessonplan_owner.staff_with_rank : @lesson_plan.lessonplan_owner.name}"],
                ["","Bidang Subjek",":","#{@lesson_plan.schedule_item.weeklytimetable_topic.full_parent }"],
                ["","Topik",":","#{@lesson_plan.schedule_item.weeklytimetable_topic.name}"],
                ["","Tarikh (Mengikut jadual)",":","#{@lesson_plan.schedule_item.get_date_for_lesson_plan }"],
                ["","Masa",":","#{@lesson_plan.schedule_item.get_start_time+' - '+@lesson_plan.schedule_item.get_end_time}"],
                ["","Tahun dan Semester Pelatih",":","Tahun #{@lesson_plan.year} Semester #{@lesson_plan.semester}"],
                ["","Bilik / Kelas / Makmal",":","#{@lesson_plan.schedule_item.location_desc}"],
             ]
          
    table(data, :column_widths => [70,150,20,260], :cell_style => { :size => 10, :align=> :center,  :inline_format => true}) do
      columns(0).borders = []
      columns(1).borders = []
      columns(1).align = :left
      column(1).font_style = :bold
      columns(2).borders = []
      columns(3).borders = []
      columns(3).align =:left
      rows(0).height = 18
      rows(1).height = 18
      rows(2).height = 18
      rows(3).height = 18
      rows(4).height = 18
      rows(5).height = 18
      rows(6).height = 18
      self.width = 500
    end
  end 
  
  def table_report
    data = [["i.","",{content: "Keadaan kelas (tandakan / )", colspan: 4}],
             ["","","","#{'<b>/</b>' if @lesson_plan.condition_isgood == true}","", "Memuaskan"],
             ["","","","","",""],
             ["","","","#{'<b>/</b>' if @lesson_plan.condition_isgood == false}","","Tidak Memuaskan"],
             ["","","","","",""],
             ["ii.","",{content: "Peralatan (ABM)", colspan: 3},""],
             ["","",{content: "#{@lesson_plan.training_aids}", colspan: 4}],
             ["iii","",{content: "Ulasan", colspan: 3},""],
             ["","",{content: "#{@lesson_plan.summary}", colspan: 4}],
             ]
          
    table(data, :column_widths => [130,20,5,40,50,255], :cell_style => { :size => 10, :align=> :center,  :inline_format => true}) do
      columns(0).borders = []
      columns(0).align = :right
      columns(1).borders = []
      columns(1).align = :left
      columns(2).borders = []
      columns(2).align= :left
      columns(3).borders = []
      columns(3).align =:center
      columns(4).align = :left
      columns(5).align = :left
      columns(4).borders = []
      columns(5).borders = []
      cells[1,3].borders =[:top, :bottom, :left, :right]
      cells[3,3].borders =[:top, :bottom, :left, :right]
      rows(0).height = 25
      rows(1).height = 18
      rows(2).height = 5
      rows(3).height = 18
      rows(4).height = 5
      rows(5).height = 18
      rows(6).height = 18
      self.width = 500
    end
  end
  
  def table_signatory
    if @college.code=='kskbjb'
      review_by="TPA/KP"
    else
      review_by="Ketua Jabatan"
    end
    data = [["","Tandatangan Pengajar :"],
                ["","<b>Nama Pengajar :</b> #{@lesson_plan.lessonplan_owner.rank_id? ? @lesson_plan.lessonplan_owner.staff_with_rank : @lesson_plan.lessonplan_owner.name }"],
                ["","Ulasan #{review_by} : "],
                ["", "#{@lesson_plan.report_summary }"],
                ["", ""],
                ["", "Tandatangan"],
                ["", "<b>#{review_by} :</b> #{@lesson_plan.endorser.rank_id? ? @lesson_plan.endorser.staff_with_rank : @lesson_plan.endorser.name }"],
                ["","<b>Tarikh : </b>#{Date.today.try(:strftime, '%d %b %Y')}"]
             ]
          
    table(data, :column_widths => [70,430], :cell_style => { :size => 10, :align=> :center,  :inline_format => true}) do
      columns(0).borders = []
      columns(1).borders = []
      columns(1).align = :left
      #column(1).font_style = :bold
      cells[0,1].font_style= :bold
      cells[2,1].font_style= :bold
      cells[5,1].font_style= :bold
      rows(0).height = 30
      rows(1).height = 25
      rows(2).height = 18
      rows(3).height = 30
      rows(4).height = 36
      rows(5).height = 18
      rows(6).height = 18
      rows(7).height = 18
      self.width = 500
    end
  end 
  
  
end