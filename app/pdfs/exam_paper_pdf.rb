class Exam_paperPdf < Prawn::Document 
  def initialize(exam, view, college)
    super({top_margin: 30, page_size: 'A4', page_layout: :portrait })
    @exam = exam
    @view = view
    @college = college
    font "Helvetica"
    if @exam.starttime.strftime('%p')=="AM"
      @meridian_timing=" pagi"
    elsif @exam.starttime.strftime('%p')=="PM"
      if @exam.starttime.strftime('%H')==12
       @meridian_timing="tengahari"
      else
        @meridian_timing="petang"
      end
    end
    if @exam.endtime.strftime('%p')=="AM"
      @meridian_timing2=" pagi"
    elsif @exam.endtime.strftime('%p')=="PM"
      if @exam.endtime.strftime('%H')==12
        @meridian_timing2="tghari"
      else
        @meridian_timing2="petang"
      end
    end
    
    if @college.code=="kskbjb"
      if @exam.subject_id!=nil && (@exam.subject.parent.code == '1' || @exam.subject.parent.code == '2') 
	@year = "TAHUN 1  SEMESTER "
      elsif @exam.subject_id!=nil && (@exam.subject.parent.code == '3' || @exam.subject.parent.code == '4')
	@year = "TAHUN 2  SEMESTER "
      elsif @exam.subject_id!=nil && (@exam.subject.parent.code == '5' || @exam.subject.parent.code == '6')
	@year = "TAHUN 3  SEMESTER "
      end
      cover_page
      if @exam.subject.root_id ==2 #Fisioterapi have 3 cover pages
	repeat(lambda {|pg| pg > 1 && pg!=@mcqpages+1 && pg!=@mcq_seqpages+1}) do
	  page_header_non_cover
	end
      else
	if [1,4].include?(@exam.subject.root_id)
	  repeat(lambda {|pg| pg > 1 && pg!=@mcqpages+1}) do #1 cover / combine
	    page_header_non_cover
	  end
	else
	  repeat(lambda {|pg| pg > 1 && pg!=@mcqpages+1}) do #2 covers / separate
	    page_header_non_cover
	  end
	end
      end
      mcq_part if @exam.examquestions.mcqq.count > 0
      @mcqpages=page_number
      if [1, 4].include?(@exam.subject.root_id)==false
	if @exam.examquestions.seqq.count > 0
	  @coverof="seq" if @exam.subject.root_id==2
	  cover_page2
	end
      end
      seq_part if @exam.examquestions.seqq.count > 0
      @mcq_seqpages=page_number
      if @exam.subject.root_id==2
	if @exam.examquestions.meqq.count > 0
	  @coverof="meq"
	  cover_page2
	end
      end
      @before_meq=page_number
      meq_part if @exam.examquestions.meqq.count > 0
 
    elsif @college.code=="amsas"
      cover_page_amsas
      mcq_part if @exam.examquestions.mcqq.count > 0
      @mcqpages=page_number
      seq_part if @exam.examquestions.seqq.count > 0
      @mcq_seqpages=page_number
      @before_meq=page_number
      meq_part if @exam.examquestions.meqq.count > 0
    end  
  end
  
  def page_header_non_cover
    draw_text "SULIT", :at => [0,770], :size =>10
    draw_text "#{@exam.subject.subject_list}", :at => [200, 770], :size => 10
    draw_text "No.Matrik:...............................", :at => [400, 770], :size => 10
  end
  
  def cover_page
    text "SULIT", :align => :left, :size => 10
    bounding_box([10,750], :width => 500, :height => 600) do |y2|
      cover_header
      #2 for Fisioterapi - note Pn Norazebah comment's override En Iz Mohd Zaki comments
      #En Iz - combine covers for Jurupulih Perubatan Cara Kerja, Fisioterapi, Pem.Perubatan
      #Pn Norazebah (Fisioterapi requires separate covers for MCQ, SEQ, MEQ)
      if [1, 4].include?(@exam.subject.root_id) 
        if @exam.examquestions.seqq.count > 0 && @exam.examquestions.meqq.count > 0
          draw_text "SEQ / MEQ", :at => [420, 310], :size => 12, :style => :bold
        elsif @exam.examquestions.seqq.count > 0 && @exam.examquestions.meqq.count == 0
          draw_text "SEQ", :at => [430, 310], :size => 12, :style => :bold
        elsif @exam.examquestions.seqq.count == 0 && @exam.examquestions.meqq.count > 0
          draw_text "MEQ", :at => [430, 310], :size => 12, :style => :bold
        end
      else #shall includes 2(Fisioterapi) as well
        draw_text "MCQ", :at => [430, 310], :size => 12, :style => :bold
      end
      stroke do
        horizontal_rule
        vertical_line 0, 278, :at => 450
        if [1, 4].include?(@exam.subject.root_id)
          horizontal_line 400, 500, :at => 210
          horizontal_line 400, 500, :at => 140 if @exam.examquestions.seqq.count >=2
          horizontal_line 400, 500, :at => 70 if @exam.examquestions.seqq.count >=3
        end
      end
      if [1, 4].include?(@exam.subject.root_id) 
        draw_text "S1", :at => [420, 240], :size => 11
        draw_text "S2", :at => [420, 170], :size => 11 if @exam.examquestions.seqq.count >=2
        draw_text "S3", :at => [420, 100], :size => 11 if @exam.examquestions.seqq.count >=3
      end
      if [1, 4].include?(@exam.subject.root_id) 
        draw_text "Jumlah", :at => [410, 30], :size => 11
      else #shall includes 2(Fisioterapi) as well
        draw_text "Jumlah", :at => [410, 240], :size => 11
      end
      cover_mykad_matric
      table_instructions
    end  
  end
  
  def cover_page2
    #applied to all programmes EXCEPT for 1-Jurupulih Perubatan Cara Kerja & 4-Pembantu Perubatan
    #Total 3 cover pages required for 2-Fisioterapi (1st-MCQ, 2nd-SEQ, 3rd-MEQ)
    start_new_page
    text "SULIT", :align => :left, :size => 10
    bounding_box([10,750], :width => 500, :height => 600) do |y2|
      cover_header
      if @exam.subject.root_id==2 #Fisioterapi (require 3 cover pages)
        if @coverof=="seq"
          draw_text "SEQ", :at => [430, 310], :size => 12, :style => :bold
        elsif @coverof=="meq"
          draw_text "MEQ", :at => [430, 310], :size => 12, :style => :bold
        end
      else
        if @exam.examquestions.seqq.count > 0 && @exam.examquestions.meqq.count > 0
          draw_text "SEQ / MEQ", :at => [420, 310], :size => 12, :style => :bold
        elsif @exam.examquestions.seqq.count > 0 && @exam.examquestions.meqq.count == 0
          draw_text "SEQ", :at => [430, 310], :size => 12, :style => :bold
        elsif @exam.examquestions.seqq.count == 0 && @exam.examquestions.meqq.count > 0
          draw_text "MEQ", :at => [430, 310], :size => 12, :style => :bold
        end
      end
      stroke do
        horizontal_rule
        vertical_line 0, 278, :at => 450
        if @exam.subject.root_id!=2 || (@exam.subject.root_id==2 && @coverof=="seq")
          horizontal_line 400, 500, :at => 210
          horizontal_line 400, 500, :at => 140 if @exam.examquestions.seqq.count >=2
          horizontal_line 400, 500, :at => 70 if @exam.examquestions.seqq.count >=3
        end
      end
      if @exam.subject.root_id!=2 || (@exam.subject.root_id==2 && @coverof=="seq")
        #may require additional conditions for MEQ
        draw_text "S1", :at => [420, 240], :size => 11
        draw_text "S2", :at => [420, 170], :size => 11 if @exam.examquestions.seqq.count >=2
        draw_text "S3", :at => [420, 100], :size => 11 if @exam.examquestions.seqq.count >=3
      end  
      if @exam.subject.root_id==2
        draw_text "Jumlah", :at => [410, 30], :size => 11 if @coverof=="seq"
        draw_text "Jumlah", :at => [410, 240], :size => 11 if @coverof=="meq"
      else
        draw_text "Jumlah", :at => [410, 30], :size => 11
      end
      cover_mykad_matric
      table_instructions2
    end  
  end
  
  def cover_page_amsas
    text "SULIT", :align => :left, :size => 10
    image "#{Rails.root}/app/assets/images/amsas.png",  :width =>80, :height =>80, :position => :center
    move_down 10
    text "#{@college.name.upcase}", :align => :center, :style => :bold, :size => 11
    text "PUSAT LATIHAN APMM", :align => :center, :style => :bold, :size => 11
    draw_text "PEPERIKSAAN", :at => [60, 620], :size => 11
    draw_text "KURSUS", :at => [60, 600], :size => 11
    draw_text "TARIKH", :at => [60, 580], :size => 11
    draw_text "MASA", :at => [60, 560], :size => 11
    draw_text "MARKAH PENUH", :at => [60, 540], :size => 11
    draw_text "MARKAH LULUS", :at => [60, 520], :size => 11
    draw_text ":  #{@exam.subject.root.name.upcase}", :at => [200, 620], :size => 11
    draw_text ":  #{@exam.subject.name.upcase}", :at => [200, 600], :size => 11
    draw_text ":  #{@exam.exam_on.try(:strftime, '%d-%m-%Y')}", :at => [200, 580], :size => 10
    draw_text ":  #{@exam.starttime.try(:strftime, '%H:%M %P ')} - #{@exam.endtime.try(:strftime, '%H:%M %P')}", :at => [200, 560], :size => 11
    draw_text ":  #{@exam.full_marks}", :at => [200, 540], :size => 11
    draw_text ":  #{@exam.full_marks/2}", :at => [200, 520], :size => 11
    table_instructions_amsas
  end
  
  def cover_header
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
  end
  
  def cover_mykad_matric
    draw_text "No K/P .............................................................", :size=>12, :at => [80, 240]
    draw_text "No Matrik ........................................................", :size => 12, :at => [80, 220]
    move_down 100
    text "Arahan kepada calon :", :indent_paragraphs => 20
    move_down 20
  end
  
  def table_instructions
    data1 = [["", "\u2022 Jangan buka buku soalan ini sehingga diberitahu."],
            ["","\u2022 Bahagian A mengandungi 20 soalan Objektif (Respon Tunggal). Jawab SEMUA soalan pada borang OMR yang disediakan."]]
    if [1, 4].include?(@exam.subject.root_id)
      if @exam.examquestions.seqq.count > 0
        if @exam.subject.root_id==1
          data1 << ["","\u2022 Bahagian B mengandungi 2 soalan SEQ (10 markah setiap satu). Jawab DUA (2) soalan dari bahagian ini."]
        else
          data1 << ["","\u2022 Bahagian B mengandungi 3 soalan SEQ (10 markah setiap satu). Jawab DUA (2) soalan sahaja dari bahagian ini."]
        end
      end 
      if @exam.examquestions.meqq.count > 0
        data1 << ["","\u2022 Bahagian C mengandungi soalan MEQ (20 markah setiap satu)."]
      end
    end
    table(data1 , :column_widths => [20,300], :cell_style => { :size => 11}) do
         row(0..2).borders = []
         columns(0..2).borders =[]
    end 
  end
  
  def table_instructions2
    data1 = [["", "\u2022 Jangan buka buku soalan ini sehingga diberitahu."]]
    if @exam.examquestions.seqq.count > 0 && (@exam.subject.root_id!=2 || (@exam.subject.root_id==2 && @coverof=="seq"))
      if @exam.subject.root_id==5
        answer_note="Jawab semua soalan."
      else
        answer_note="Jawab DUA (2) soalan sahaja dari bahagian ini."
      end
      data1 << ["","\u2022 Bahagian B mengandungi #{@exam.examquestions.seqq.count} soalan SEQ (10 markah setiap satu). "+answer_note]
    elsif @exam.examquestions.meqq.count > 0 && (@exam.subject.root_id!=2 || (@exam.subject.root_id==2 && @coverof=="meq"))
      data1 << ["","\u2022 Bahagian C mengandungi soalan MEQ (20 markah setiap satu)."]
    end
    table(data1 , :column_widths => [20,300], :cell_style => { :size => 11}) do
         row(0..2).borders = []
         columns(0..2).borders =[]
    end 
  end
  
  def table_instructions_amsas
    move_down 180
    data1 = [["",{content: "<u>ARAHAN</u>", colspan: 2}], ["", "1.", "<b>JAWAB SEMUA SOALAN</b>"], ["", "2.", "PASTIKAN PERKARA BERIKUT <b>DITULIS PADA KERTAS JAWAPAN:</b>"], ["","", "2.1  NAMA"], ["","", "2.2  NO. KAD PENGENALAN"], ["","", "2.3  KELAS"], ["","", "2.4  TARIKH"], ["","", "2.5  PEPERIKSAAN"], ["","3", "<b><u>DILARANG</u></b> MEMBUKA KERTAS SOALAN SEBELUM DIARAHKAN OLEH PENGAWAS PEPERIKSAAN."], ["", "4.", "'"+"ADALAH INI KAMU DENGAN SECARA RASMINYA DIBERI AMARAN BAHAWA MENIRU SEMASA PEPERIKSAAN ADALAH SATU PERBUATAN YANG DILARANG. JIKA KAMU DISABIT DENGAN KESALAHAN INI, TINDAKAN TATATERTIB DAN TINDAKAN YANG PERLU BOLEH DIAMBIL KE ATAS KAMU SESUAI DENGAN ARAHAN YANG DIBERIKAN. SEBELUM PEPERIKSAAN DIMULAKAN, KAMU DIBERIKAN PELUANG TERAKHIR UNTUK MEMBUAT SEBARANG PENGAKUAN DAN BOLEH SETERUSNYA MEMBERSIHKAN DIRI DARI BAHAN YANG BOLEH MENYABITKAN KEPADA KES MENIRU SEMASA PEPERIKSAAN."+"'"]]
    table(data1 , :column_widths => [30, 20, 460], :cell_style => { :size => 11, :inline_format => true, :padding => [0, 0, 0, 0]}) do
         row(0..2).borders = []
         row(0).font_style=:bold
         columns(0..2).borders =[]
	 rows(0..2).height=30
         rows(3..6).height=15
         rows(7..8).height=35
	 rows(9).height=162
	 row(9).column(2).font_style=:bold
    end 
  end

  def mcq_part
    start_new_page 
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
    #START-ASSIGN QUESTIONS WITH SEQUENCE INTO HASH
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
    pagenos=[]
    0.upto(@tosort_seqid.count-1) do |count2|
      move_down 5
      q = Examquestion.find(@seq_questionid[count2])
      
      #check COMPLETE question set HEIGHT, set default as 180 if less than 180
      q_string=q.question.strip
      lines=q_string.size/89
      mod_lines=q_string.size%89
      if mod_lines==0
        aa=lines*10+10
      else #got balance
        if lines < 1
          aa=10
       elsif lines==1
         aa=lines*10+10
       else
          aa=(lines+1)*10+10
        end
      end   
      if q.diagram.exists? then
        imageheight=130+5+10 #image caption line(5+10)
      else
        imageheight=0
      end
      qset_height=5+aa+imageheight+10+50         #questiondefault height=10, examanswers=50(inc blank row)
      qset_height+=50 if q.answerchoices.count > 0
      qset_height=75 if qset_height < 75 && imageheight==0
      qset_height=220 if qset_height < 220 && imageheight==145
      #text "qset_height = #{qset_height}  y = #{y} cursor=#{cursor}"
      
      #move to next page if space is inadequate for COMPLETE question set
      if qset_height > cursor #y
        start_new_page
        move_down 20
        #text "sebab tak muat"
      end
      
      #display diagram
      if q.diagram.exists? then
        draw_text "#{count2+1})", :at => [10, cursor-8]
        #image "#{Rails.root}/app/assets/images/logo_kerajaan.png",  :width =>97.2, :height =>77.76, :position => :center
        #image "#{Rails.root}/public/assets/examquestions/100/original/screen_cap.png", :position => :center
        image "#{Rails.root}/public#{q.diagram.url.split("?")[0]}", :position => :center, :height => 130
        move_down 5
        text "#{q.diagram_caption}", :align => :center, :style => :italic, :size => 11
      else
        draw_text "#{count2+1})", :at => [10, cursor-20]
      end
      move_down 20

      #display question
      text_box q_string, :at => [30, cursor+8], :width => 450, :height => 10, :overflow => :expand, :align => :justify, :inline_format => true
#       bounding_box([30, cursor+8], :width => 450) do
#           formatted_text_box([{ :text => q_string, :align => :justify,  :width => 450, :height => 40,  :overflow => :expand}])
#       end
      move_down aa
 
      #display answerchoices(i, ii, ii, iv) & answers option(A, B, C, D)
      if q.answerchoices.count > 0
        q.answerchoices.sort_by(&:item).each do |ac|
          text "   #{ac.item}  #{ac.description}", :indent_paragraphs => 40
        end
        move_down 10
      end
      q.examanswers.sort_by(&:item).each do |eans|
         text "   #{eans.item}  #{eans.answer_desc}", :indent_paragraphs => 40
      end
      move_down 10

      if pagenos.include?(page_number-1)==false 
         draw_text "#{@exam.exam_on.strftime('%d ')+I18n.t(:'date.month_names')[@exam.exam_on.month]+@exam.exam_on.strftime(' %Y')}", :at => [0,0], :size => 10
         pagenos << page_number-1
         draw_text "muka surat #{page_number-1}", :at => [230,0], :size => 10
         draw_text "SULIT", :at => [500,0], :size => 10
      end

    end #ENDING @tosort_seqid.count-1
  end

  def seq_part
     start_new_page
     move_down 20
     if @exam.subject.root_id==5
       text "Bahagian B. Jawab semua soalan.", :align => :left, :size => 12, :style => :bold
     else
       text "Bahagian B. Jawab DUA soalan sahaja.", :align => :left, :size => 12, :style => :bold
     end
     move_down 10
     
     #########
     sequ = @exam.sequ.split(",")
     @seq_questionid = [] 
     hash_seqid = Hash.new
     @tosort_seqid = Hash.new 
     select_questionid = []  
     count = 0
     #START-ASSIGN QUESTIONS WITH SEQUENCE INTO HASH
     for examquestion in @exam.examquestions.seqq
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
     pagenos=[]
     #@exam.examquestions.seqq.each_with_index do |q, indx|
     0.upto(@tosort_seqid.count-1) do |indx|
       q = Examquestion.find(@seq_questionid[indx])
 
       #reactivate this part to DISPLAY Main SEQ question in remaining space of Previous SEQ question set - start- En Iz (29Dec2015)
       ##check COMPLETE Main SEQ question set HEIGHT (main question+diagram[if any]), set default as 180 if less than 180
       q_string=q.question
       lines=q_string.size/89
       mod_lines=q_string.size%89
       aa= (lines*20) if mod_lines==0
       aa= ((lines+1)*20) if mod_lines>0
       #if q.diagram.exists? then
       #  imageheight=130+5+10
       #else
       #  imageheight=0
       #end
       #qset_height=20+10+aa+20+imageheight
       ##qset_height=180 if qset_height <180
       #qset_height=70 if qset_height < 70 && imageheight==0
       #qset_height=215 if qset_height < 215 && imageheight==145
       ##text "qset_height = #{qset_height}  y = #{y}"
      
       ##move to next page if space is inadequate for Main SEQ question set
       #if qset_height > y
       #  start_new_page
       #  move_down 20
       #  #text "sebab tak muat mainQ"
       #end
       #reactivate this part to DISPLAY Main SEQ question in remaining space of Previous SEQ question set - end- En Iz (29Dec2015) 

       #otherwise - use BELOW - start   
       #start a NEW page for every SEQ question set (for 2nd question onwards)
       if indx > 0
         start_new_page
         move_down 20
       end
       #otherwise - end

       #display diagram
       if q.diagram.exists? then
         draw_text "#{indx+1})", :at => [10, cursor-8]
         image "#{Rails.root}/public#{q.diagram.url.split("?")[0]}", :position => :center, :height => 140
         move_down 5
         text "#{q.diagram_caption}", :align => :center, :style => :italic, :size => 11
       else
         draw_text "#{indx+1})", :at => [10, cursor-20]
       end
       move_down 20
       
       #display MAIN SEQ question
       if q.question
         q_string=q.question 
         #draw_text "#{indx+1}", :at => [10, cursor]
         text_box q_string, :at => [30, cursor+8], :width => 450, :height => 40, :overflow => :expand, :align => :justify, :inline_format => true
         lines=q_string.size/89
         mod_lines=q_string.size%89
         move_down aa
       end
       total_valid=0
       q.shortessays.each{|x|total_valid+=1 unless x.subquestion.blank? && x.subquestion.size==0}
       subq_count=0
       for subq in q.shortessays
         unless subq.subquestion.blank? && subq.subquestion.size==0        
           #check subquestion HEIGHT
           subq_string=subq.subquestion
           empty_lines=subq.submark.to_i*2
           lines=subq_string.size/85
           mod_lines=subq_string.size/85
           if mod_lines>0
             bb= ((lines+1)*20) 
           else
             if  lines > 0
               bb= (lines*20)
             else
               bb=20
             end
           end
           subqset_height=bb+empty_lines*20+(20+30)#(20+20+30)
           subqset_height=150 if subqset_height <150

           #move to next page if space is inadequate for COMPLETE subquestion set
           if subqset_height > y && subq_count < q.shortessays.count 
             start_new_page
             move_down 50
             #text "sebab tak muat subqq #{subq_count}"
           end

           #display subquestion: numbering, marks, squestion & empty lines
           if q.question
             draw_text "#{subq.item})", :at => [30, cursor] 
           else 
             draw_text "#{indx+1}#{subq.item})",  :at => [10, cursor]
           end
           draw_text "("+subq.submark.to_i.to_s+" markah)",  :at => [455, cursor]
           text_box subq_string, :at => [50, cursor+8], :width => 400, :height => 40, :overflow => :expand, :align => :justify, :inline_format => true
           move_down 20 if lines > 0
           0.upto(empty_lines) do |cnt|
             move_down 20
             draw_text  "#{'_'*80}", :at => [30, cursor]
           end
           move_down 30  
           subq_count+=1
         end

         if pagenos.include?(page_number-1)==false 
           draw_text "#{@exam.exam_on.strftime('%d ')+I18n.t(:'date.month_names')[@exam.exam_on.month]+@exam.exam_on.strftime(' %Y')}", :at => [0,0], :size => 10
           pagenos << page_number-1
           if [1, 4].include?(@exam.subject.root_id)
             draw_text "muka surat #{page_number-1}", :at => [230,0], :size => 10
           else
             draw_text "muka surat #{page_number-1-@mcqpages}", :at => [230,0], :size => 10
           end
           draw_text "SULIT", :at => [500,0], :size => 10
         end
       end #ENDING for shortessays

       if pagenos.include?(page_number-1)==false 
         draw_text "#{@exam.exam_on.strftime('%d ')+I18n.t(:'date.month_names')[@exam.exam_on.month]+@exam.exam_on.strftime(' %Y')}", :at => [0,0], :size => 10
         pagenos << page_number-1
         if [1, 4].include?(@exam.subject.root_id)
           draw_text "muka surat #{page_number-1}", :at => [230,0], :size => 10
         else
           draw_text "muka surat #{page_number-1-@mcqpages}", :at => [230,0], :size => 10
         end
         draw_text "SULIT", :at => [500,0], :size => 10
       end
     end   #ENDING upto(@tosort_seqid.count-1)
   end
   
   def meq_part
     start_new_page
     move_down 20
     if @exam.subject.root_id==2 #Fisioterapi (require 3 cover pages)
       text "Bahagian C.", :align => :left, :size => 12, :style => :bold 
     else
       if @exam.examquestions.seqq.count > 0 && @exam.examquestions.meqq.count > 0
         text "Bahagian C.", :align => :left, :size => 12, :style => :bold
       elsif @exam.examquestions.seqq.count == 0 && @exam.examquestions.meqq.count > 0  #Kejururawatan - MCQ & MEQ (2 covers)
         text "Bahagian B. Jawab DUA soalan sahaja.", :align => :left, :size => 12, :style => :bold
       end
     end
     move_down 10
     #########
     sequ = @exam.sequ.split(",")
     @seq_questionid = [] 
     hash_seqid = Hash.new
     @tosort_seqid = Hash.new 
     select_questionid = []  
     count = 0
     #START-ASSIGN QUESTIONS WITH SEQUENCE INTO HASH
     for examquestion in @exam.examquestions.meqq
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
     pagenos=[]
     #@exam.examquestions.meqq.each_with_index do |q, indx|
     0.upto(@tosort_seqid.count-1) do |indx|
       q = Examquestion.find(@seq_questionid[indx])

       #check COMPLETE question set HEIGHT, set default as 180 if less than 180
       q_string=q.question
       lines=q_string.size/100
       mod_lines=q_string.size%100
       #aa= (lines*20) if mod_lines==0
       #aa= (lines*20+10) if mod_lines>0
       if mod_lines>0
         aa= ((lines+1)*20) 
       else
         if  lines > 0
           aa= (lines*20)
         else
           aa=20
         end
       end
       if q.diagram.exists? then
         imageheight=130+5+20
       else
         imageheight=0
       end
       qset_height=20+10+aa+20+imageheight
       qset_height=70 if qset_height < 70 && imageheight==0
       qset_height=225 if qset_height < 225 && imageheight==155
       #text "qset_height = #{qset_height}  y = #{y}"
      
       #move to next page if space is inadequate for COMPLETE question set
       if qset_height > y
         start_new_page
         move_down 20
         #text "sebab tak muat meq"
       end
       
       if q.diagram.exists? then
         draw_text "#{indx+1})", :at => [10, cursor-8]
         image "#{Rails.root}/public#{q.diagram.url.split("?")[0]}", :position => :center, :height => 130
         move_down 5
         text "#{q.diagram_caption}", :align => :center, :style => :italic, :size => 11
       else
         draw_text "#{indx+1})", :at => [10, cursor-20]
       end
       move_down 20
       q_string=q.question 
       #draw_text "#{indx+1}", :at => [10, cursor]
       text_box q_string, :at => [30, cursor+8], :width => 480, :height => 40, :overflow => :expand, :align => :justify, :inline_format => true
       draw_text "("+q.marks.to_i.to_s+" markah)",  :at => [455, cursor-(aa)]
       move_down (aa)+20
 
       if pagenos.include?(page_number-1)==false 
         pagenos << page_number-1
         draw_text "#{@exam.exam_on.strftime('%d ')+I18n.t(:'date.month_names')[@exam.exam_on.month]+@exam.exam_on.strftime(' %Y')}", :at => [0,0], :size => 10
         draw_text "SULIT", :at => [500,0], :size => 10
         if [1, 4].include?(@exam.subject.root_id)
           draw_text "muka surat #{page_number-1}", :at => [230,0], :size => 10
         elsif @exam.subject.root_id==2
           draw_text "muka surat #{page_number-1-@mcq_seqpages}", :at => [230,0], :size => 10
         else
           #3-Kejururawatan - separate (2 covers) (MCQ+MEQ or MEQ/SEQ cover), 
           #5-Radiografi - separate cover too, but checking not required here coz Radiografi has no MEQ at all (refer Struktur Penilaian)
           if @exam.subject.root.id==3 #Kejururawatan - 2 covers :  MCQ cover + MEQ/SEQ cover   - sample record ID 19
             draw_text "muka surat #{page_number-1-@mcqpages}", :at => [230,0], :size => 10 
           else
             draw_text "muka surat #{page_number-1}", :at => [230,0], :size => 10  #when there's only 1 cover exist   - sample record ID 84 (Pos Basik Koronari)
           end
         end
       end
     end #ENDING - @tosort_seqid.count-1
   end
 
end