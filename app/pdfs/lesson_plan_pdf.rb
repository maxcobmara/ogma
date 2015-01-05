class Lesson_planPdf< Prawn::Document
  def initialize(lesson_plan, view)
    super({top_margin: 10, page_size: 'A4', page_layout: :landscape })
    @lesson_plan = lesson_plan
    @view = view
    font "Times-Roman"
    text "BPL.KKM.PK(T04D/09)", :align => :right, :size => 9
    move_down 20
    image "#{Rails.root}/app/assets/images/logo_kerajaan.png", :position => :center, :scale => 0.65
    move_down 10
    text "KEMENTERIAN KESIHATAN MALAYSIA", :style => :bold, :align => :center
    text "KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU", :style => :bold, :align => :center
    move_down 15
    text "PELAN PENGAJARAN#{'KULIAH'  if @lesson_plan.schedule_item.lecture_method == 1} #{'TUTORIAL'  if @lesson_plan.schedule_item.lecture_method == 2} #{'AMALI'  if @lesson_plan.schedule_item.lecture_method == 3}", :style => :bold, :align => :center, :size => 11
    move_down 5
    table_details
    start_new_page
    move_down 30
    table_methodologies
    move_down 30
    table_signatory
  end
  
  def table_details
    data = [["", "Nama Pengajar","#{@lesson_plan.lessonplan_owner.name }"],
            ["", "Kumpulan Pelatih","#{@lesson_plan.schedule_item.weeklytimetable.schedule_intake.group_with_intake_name}"],
            ["", "Bilangan Pelatih","#{@lesson_plan.student_qty}"],
            ["", "Tahun","#{ @lesson_plan.year}"],
            ["", "Semester","#{ @lesson_plan.semester}"],
            ["", "Topik / Tajuk","#{@lesson_plan.schedule_item.weeklytimetable_topic.full_parent}<br>#{@lesson_plan.schedule_item.weeklytimetable_topic.name}"],
            ["", "Tarikh & Masa","#{@lesson_plan.schedule_item.get_date_for_lesson_plan} (#{@lesson_plan.schedule_item.get_start_time+' - '+ @lesson_plan.schedule_item.get_end_time})"],
            ["", "Pengetahuan Terdahulu<br><i>(Prerequisite)</i>","#{@lesson_plan.prerequisites}"],
            ["","Objektif Pembelajaran","#{ @lesson_plan.schedule_item.weeklytimetable_topic.topic_details.last.try(:objctives)}"],
            ["","Rujukan","#{@lesson_plan.reference}"]
            ]
          
    table(data, :column_widths => [30,290,430], :cell_style => { :size => 11, :align=> :center,  :inline_format => true}) do
      self.width = 750
      columns(0).borders =[]
      columns(1).align = :left
      columns(2).align = :left
      column(1).font_style = :bold
      rows(0..9).height = 20
    end
  end
  
  def table_methodologies          
    table(methodologies_line_items_rows, :column_widths => [30,90,140,120,100,120,150], :cell_style => { :size => 11, :align=> :center,  :inline_format => true}) do
      self.width = 750
      columns(0).borders =[]
      columns(1).align = :left
      columns(2).align = :left
      column(1).font_style = :bold
      rows(0).align=:center
      row(0).font_style =:bold
      row(1).font_style =:bold
      rows(0..1).height = 20
      row(0).background_color = 'E6E6E6'
      cells[0,0].background_color = 'FFFFFF'
      row(1).background_color = 'E6E6E6'
      cells[1,0].background_color = 'FFFFFF'
    end
  end
  
  def methodologies_line_items_rows
    header = [["",{content: "METHODOLOGI", colspan: 6}],
                    ["","Masa","Isi kandungan/Subtopik","Aktiviti Pengajar","Aktiviti Pelatih","Alat Bantuan Mengajar","Penilaian"]] 
    header +
    @lesson_plan.lessonplan_methodologies.map do |l|
      ["","#{l.start_meth.try(:strftime, '%H:%M')+' - '+l.end_meth.try(:strftime,'%H:%M %p')}<br>(#{ (((l.end_meth - l.start_meth )/60 ) % 60).to_i} minit)",
       "#{l.content}",
       "#{l.lecturer_activity}",
       "#{l.student_activity}",
       "#{l.training_aids}",
       "#{l.evaluation}"]
    end
  end
  
  def table_signatory
    data = [["","#{@lesson_plan.prepared_by? ? @lesson_plan.lessonplan_creator.name : '-' }", 
             "#{@lesson_plan.endorsed_by? ? @lesson_plan.endorser.name : "-"  }"],
              ["","#{ @lesson_plan.prepared_by? ? @lesson_plan.lessonplan_creator.positions.first.try(:name) : '-' }",
               "#{@lesson_plan.endorsed_by? ? @lesson_plan.endorser.positions.first.try(:name) : "-" }"],
             ["","Kolej Sains Kesihatan Bersekutu Johor Bahru","Kolej Sains Kesihatan Bersekutu Johor Bahru"],
             ["","Tarikh : #{@lesson_plan.submitted_on? ? @lesson_plan.submitted_on.try(:strftime,'%d-%b-%Y') : "Belum Dihantar"}","Tarikh : #{@lesson_plan.hod_approved_on? ? @lesson_plan.hod_approved_on.try(:strftime,'%d-%b-%Y') : "Belum Diluluskan"}"],
            ]
          
    table(data, :column_widths => [120,360,270], :cell_style => { :size => 11, :align=> :center,  :inline_format => true}) do
      self.width = 750
      columns(0).borders =[]
      columns(1).borders =[]
      columns(2).borders =[]
      columns(1).align = :left
      columns(2).align = :left
      row(0).font_style = :bold
      row(0..1).height = 20
      rows(2).height = 40
      rows(3).height = 20
    end
  end
  
end