class Exam_paperPdf < Prawn::Document 
  def initialize(exam, view)
    super({top_margin: 30, page_size: 'A4', page_layout: :portrait })
    @exam = exam
    @view = view
    if @exam.subject_id!=nil && (@exam.subject.parent.code == '1' || @exam.subject.parent.code == '2') 
      @year = "TAHUN 1  SEMESTER "
    elsif @exam.subject_id!=nil && (@exam.subject.parent.code == '3' || @exam.subject.parent.code == '4')
      @year = "TAHUN 2  SEMESTER "
    elsif @exam.subject_id!=nil && (@exam.subject.parent.code == '5' || @exam.subject.parent.code == '6')
      @year = "TAHUN 3  SEMESTER "
    end
    if @exam.starttime.strftime('%p')=="AM"
      @meridian_timing=" pagi"
    elsif @exam.starttime.strftime('%p'=="PM")
      if @exam.starttime.strftime('%H')==12
       @meridian_timing="tengahari"
      else
        @meridian_timing="petang"
      end
    end
    if @exam.endtime.strftime('%p')=="AM"
      @meridian_timing2=" pagi"
    elsif @exam.endtime.strftime('%p'=="PM")
      if @exam.endtime.strftime('%H')==12
        @meridian_timing2="tghari"
      else
        @meridian_timing2="petang"
      end
    end
    font "Times-Roman"
    text "SULIT", :align => :left, :size => 10
    cover_page
    ###second page(1) starts here
    start_new_page
    repeat(2..3) do #repeative 
      draw_text "SULIT", :at => [0,770], :size =>10
      draw_text "#{@exam.subject.subject_list}", :at => [200, 770], :size => 10
      draw_text "No.Matrik:...............................", :at => [400, 770], :size => 10
    end
    draw_text "#{@exam.exam_on.strftime('%d ')+I18n.t(:'date.month_names')[@exam.exam_on.month]+@exam.exam_on.strftime(' %Y')}", :at => [0,0], :size => 10
    draw_text "muka surat #{page_number-1}", :at => [230,0], :size => 10
    draw_text "SULIT", :at => [500,0], :size => 10
    ###
    mcq_part
  end
  
  def cover_page
    bounding_box([10,750], :width => 500, :height => 600) do |y2|
      move_down 20
      stroke_bounds
      image "#{Rails.root}/app/assets/images/logo_kerajaan.png",  :width =>68.04, :height =>54.432, :position => :center
      move_down 10
      text "LEMBAGA PENDIDIKAN", :align => :center, :size => 10, :style => :bold
      text "KEMENTERIAN PENDIDIKAN MALAYSIA", :align => :center, :size => 10, :style => :bold
      move_down 10
      stroke do
        horizontal_rule
      end
      move_down 20
      text @exam.render_full_name.upcase, :align => :center,  :size => 11, :style => :bold
      text "#{@exam.subject_id? ? @year + @exam.subject.parent.code.to_s : ''}", :align => :center, :size => 11, :style => :bold
      text "#{@exam.subject_id? ? "KURSUS "+@exam.subject.root.course_type.upcase+" "+@exam.subject.root.name.upcase : ""}", :align  => :center, :size => 11, :style => :bold
      move_down 20
      stroke do
        horizontal_rule
      end
      move_down 20
      text "#{@exam.subject_id? ? @exam.subject.name : "" }",  :align => :center, :size => 11, :style => :bold
      text "#{@exam.subject_id? ? @exam.subject.code : ""}", :align => :center, :size => 11, :style => :bold
      move_down 11
      stroke do
        horizontal_rule
        vertical_line 0, 348, :at => 400
      end
      draw_text "Tarikh : #{ @exam.exam_on.blank? ? '-' : @exam.exam_on.strftime('%d ')+I18n.t(:'date.month_names')[@exam.exam_on.month]+@exam.exam_on.strftime(' %Y')+ ' ('+ I18n.t(:'date.day_names')[@exam.exam_on.wday] +')'}", :at => [110, 320], :size => 12
      draw_text "Masa : #{@exam.starttime.strftime('%H:%M')+@meridian_timing+' - '+@exam.endtime.strftime('%H:%M') +@meridian_timing}", :at => [110, 300], :size => 12
      move_down 70
      #draw_text @exam.examquestions.first.questiontype, :at => [430, 310], :size => 12, :style => :bold
      draw_text "SEQ", :at => [430, 310], :size => 12, :style => :bold
      stroke do
        horizontal_rule
        vertical_line 0, 278, :at => 450
        horizontal_line 400, 500, :at => 210
        horizontal_line 400, 500, :at => 140
        horizontal_line 400, 500, :at => 70
      end
      draw_text "S1", :at => [420, 240], :size => 11
      draw_text "S2", :at => [420, 170], :size => 11
      draw_text "S3", :at => [420, 100], :size => 11
      draw_text "Jumlah", :at => [410, 30], :size => 11
      draw_text "No K/P .............................................................", :size=>12, :at => [80, 240]
      draw_text "No Matrik ........................................................", :size => 12, :at => [80, 220]
      move_down 100
      text "Arahan kepada calon :", :indent_paragraphs => 20
      move_down 20
      table_instructions
    end  
  end
  
  def table_instructions
    data1 = [["", "\u2022 Jangan buka buku soalan ini sehingga diberitahu."],
            ["","\u2022 Bahagian A mengandungi 20 soalan Objektif (Respon Tunggal). Jawab SEMUA soalan pada borang OMR yang disediakan."],
            ["","\u2022 Bahagian B mengandungi 3 soalan SEQ (10 markah setiap satu). Jawab DUA (2) soalan sahaja dari bahagian ini."]]
    table(data1 , :column_widths => [20,300], :cell_style => { :size => 11}) do
         row(0..2).borders = []
         columns(0..2).borders =[]
    end 
  end

  def mcq_part
    move_down 20
    text "Bahagian A. Jawab SEMUA soalan", :align => :left, :size => 12, :style => :bold
    move_down 10
    
    #########
    sequ = @exam.sequ.split(",")
    @seq_questionid = [] 
    hash_seqid = Hash.new
    @tosort_seqid = Hash.new 
    select_questionid = []  
    count = 0

    #START-ASSIGN QUESTIONS WITH SEQUENCE INTO HASH & QUESTIONS WITHOUT SEQUENCE INTO ARRAY ACCORDINGLY-->
    for examquestion in @exam.examquestions.mcqq
      if sequ[count] != "Select" 
        hash_seqid = {sequ[count] => examquestion.id}
        @tosort_seqid = @tosort_seqid.merge(hash_seqid)
      else
        select_questionid << examquestion.id
      end
      count+=1
    end 

    #for question with sequence-SORT by its' sequence
    @tosort_seqid.sort_by{|k,v|k.to_i}.each do |x,y|   #to overcome this sort result:1,10,11,2,3,4,5,6,7,8,9
      @seq_questionid << y 
    end 
    #########

    0.upto(@tosort_seqid.count-1) do |count2|
      q = Examquestion.find(@seq_questionid[count2])
      if q.diagram.exists? then
        #image "#{Rails.root}/app/assets/images/logo_kerajaan.png",  :width =>97.2, :height =>77.76, :position => :center
        #image "#{Rails.root}/public/assets/examquestions/100/original/screen_cap.png", :position => :center
        image "#{Rails.root}/public#{q.diagram.url.split("?")[0]}", :position => :center, :height => 140
        move_down 5
        text "#{q.diagram_caption}", :align => :center, :style => :italic, :size => 11
      end
      @counting=count2
      move_down 20

      q_string=q.question#@view.simple_format(q.question)#.gsub(/<br>/,"").gsub(/<br\/>/,"")
      draw_text "#{count2+1}", :at => [10, cursor]
      text_box q_string, :at => [30, cursor+8], :width => 450, :height => 40, :overflow => :expand, :align => :justify, :inline_format => true
#       bounding_box([30, cursor+8], :width => 450) do
#           formatted_text_box([{ :text => q_string, :align => :justify,  :width => 450, :height => 40,  :overflow => :expand}])
#       end
     
      lines=q_string.size/80
      move_down (lines*20+5)
 
      if q.answerchoices.count > 0
        q.answerchoices.sort_by(&:item).each do |ac|
        text "   #{ac.item}  #{ac.description}", :indent_paragraphs => 40
      end
      end
      move_down 10
      q.examanswers.sort_by(&:item).each do |eans|
         text "   #{eans.item}  #{eans.answer_desc}", :indent_paragraphs => 40
      end
      move_down 10
          
      if y < 140
        start_new_page
        move_down 20
        draw_text "#{@exam.exam_on.strftime('%d ')+I18n.t(:'date.month_names')[@exam.exam_on.month]+@exam.exam_on.strftime(' %Y')}", :at => [0,0], :size => 10
        draw_text "muka surat #{page_number-1}", :at => [230,0], :size => 10
        draw_text "SULIT", :at => [500,0], :size => 10
      end

#       table(line_item_rows, :column_widths => [30,30, 400, 80], :cell_style => { :size => 12,  :inline_format => :true}) do
#         row(0).font_style = :bold
#         row(0..10).borders = []
#         columns(0..6).borders = []
#         self.header = true
#         self.width = 540
#         header = true
#       end
      
    end
    
  end
  
#   def line_item_rows
#     counter = counter || 0
#     header = [[ "", "","", ""]]   
#     content_q=[]
#       
#           q = Examquestion.find(@seq_questionid[@counting])
#           content_q << [@counting+1, {content: q.question, colspan: 2}, ""] 
#           if q.answerchoices.count > 0
#             q.answerchoices.sort_by(&:item).each do |ac|
#               content_q << ["", ac.item, ac.description, ""]
#             end
#             content_q << ["","","",""]
#           end
#           q.examanswers.sort_by(&:item).each do |eans|
#             content_q << ["", eans.item, eans.answer_desc, "" ]
#           end
#           content_q << ["","","",""]
#       
#     header+content_q
#   end
  
end
