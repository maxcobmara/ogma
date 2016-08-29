class InstructorevaluationPdf < Prawn::Document  
  def initialize(instructor_appraisal, view, college)
    super({top_margin: 40, page_size: 'A4', page_layout: :portrait })
    @appraisal  = instructor_appraisal
    @view = view
    font "Helvetica"
    if college.code=="kskbjb"
      move_down 10
    end
    #image "#{Rails.root}/app/assets/images/logo_kerajaan.png",  :width =>97.2, :height =>77.76
    bounding_box([10,770], :width => 400, :height => 100) do |y2|
       image "#{Rails.root}/app/assets/images/logo_kerajaan.png",  :width =>97.2, :height =>77.76
    end
    bounding_box([150,750], :width => 350, :height => 100) do |y2|
      if college.code=="kskbjb"
        move_down 30
        text "#{college.name}"
        move_down 1
        text "#{I18n.t('exam.evaluate_course.title')}"
      else
        draw_text "PPL APMM", :at => [80, 85], :style => :bold
        draw_text "NO.DOKUMEN: BK-KKM-04-01", :at => [15, 70], :style => :bold
        draw_text "BORANG PENILAIAN DIRI UNTUK JURULATIH", :at => [-25, 45], :style => :bold
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
    move_down 30
    table_main
    move_down 70
    table_signatory
    move_down 230
    table_ending
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  def table_main
    ab=@appraisal
    arr_marks=[]
    arr_marks << ab.q1 << ab.q2 << ab.q3 << ab.q4 << ab.q5 << ab.q6 << ab.q7 << ab.q8 << ab.q9 << ab.q10 << ab.q11 << "" << ab.q12 << ab.q13 << ab.q14 << ab.q15 << ab.q16 << ab.q17 << ab.q18 << ab.q19 << ab.q20 << ab.q21 << ab.q22 << ab.q23 << ab.q24 << ab.q25 << ab.q26 << ab.q27 << ab.q28 << ab.q29 << ab.q30 << ab.q31 << ab.q32 << ab.q33 << ab.q34 << ab.q35 << ab.q36 << ab.q37 << ab.q38 << ab.q39 << ab.q40 << ab.q41 << ab.q42 << ab.q43 << ab.q44 << ab.q45 << ab.q46 << ab.q47 << ab.q48
    total_two=total_one=0
    for mark in arr_marks
      total_two+= mark if mark==2
      total_one+=mark if mark==1
    end
    
    @general_notes1="Panduan ini adalah untuk anda sendiri mengukur tahap kebolehan anda untuk melakukan tugas sebagai seorang jurulatih. Tiada sesiapa perlu melihat pencapaian anda. Jujurlah dengan diri anda sendiri. Jangan keterlaluan dalam memberi skor dan kenalpasti aspek yang perlu anda perbaiki."
    @notes2="Borang ini perlu diisi oleh anda setiap 3 BULAN bagi mengukur kebolehan anda dan ianya akan diaudit oleh staf penilai Bahagian Pembangunan Kompetensi dan Kawalan Mutu."
    @notes3="Teliti setiap soalan betul-betul, kemudian isikan ruang dengan skor yang memaparkan pengamalan anda dalam melaksanakan tugas kejurulatihan. Skor yang diguna pakai adalah seperti berikut:"
    @notes3a="Jika dipraktikkan setiap masa <br>Jika kerap dipraktikkan<br> Jika jarang tidak dipraktikkan"
    @notes3b="- 2<br>- 1<br>- 0"
    @notes4="Campurkan kesemua skor anda dan kenalpasti di peringkat mana anda berada:"
    @notes4a="90 dan ke atas                  -     <b>BAIK</b><br>89-65                                -     <b>MEMUASKAN</b><br>64 atau kurang                 -     <b>TIDAK MEMUASKAN</b>"
    @notes5="Jika pencapaian skor anda adalah di bawah 79, anda harus sedar bahawa anda memerlukan peningkatan kemahiran sikap dan pengetahuan. Anda dikehendaki mengubah cara dan tabiat mengajar demi kepentingan pelatih dan organisasi ini."
    @notes6="Sila hubungi Bahagian Pembangunan Kompetensi dan Kawalan Mutu untuk perbincangan dan bantuan khidmat nasihat."
    
    data2=[[{content: "<u>TUJUAN</u>", colspan: 7}],
          ["*", {content: @general_notes1, colspan: 6}], 
          ["*", {content: @notes2, colspan: 6}],
          ["*", {content: @notes3, colspan: 6}],
          ["", "*<br>*<br>*", @notes3a, {content: @notes3b, colspan: 4}],
          ["*", {content: @notes4, colspan: 6}],
          ["", "*<br>*<br>*", {content: @notes4a, colspan: 5}],
          ["*", {content: @notes5, colspan: 6}],
           ["*", {content: @notes6, colspan: 6}],["","","","","","",""]]
    table(data2, :column_widths => [25,15, 185,175, 40, 40, 40], :cell_style => {:size=>11, :borders => [:left, :right, :top, :bottom],  :inline_format => :true, :padding=>[2,5,3,5]}) do
      a = 0
      b = 1
      row(0).font_style=:bold
      row(0).borders=[:left, :top, :right]
      row(1..3).column(0).borders=[:left]
      row(1..3).column(1).borders=[:right]
      row(4).column(0).borders=[:left]
      row(4).column(1..2).borders=[]
      row(4).column(3).borders=[:right]
      row(5).column(0).borders=[:left]
      row(5).column(1).borders=[:right]
      row(6).column(0).borders=[:left]
      row(6).column(1..2).borders=[]
      row(6).column(2).borders=[:right]
      row(7..8).column(0).borders=[:left]
      row(7..8).column(1).borders=[:right]
      row(9).height=8
      row(9).column(1..5).borders=[]
      row(9).column(0).borders=[:left]
      row(9).column(6).borders=[:right]
      while a < b do
        a=+1
      end
    end
    
    data=[[{content: "SIRI", colspan: 2},{content: "SOALAN", colspan: 2},"2","1","0"]]
    
    data << [{content: "1", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q1')}", colspan: 2},"#{@appraisal.q1==2 ? '<b>2</b>' : '2'}","#{@appraisal.q1==1 ? '<b>1</b>' : '1'}","#{@appraisal.q1==0 ? '<b>0</b>' : 0}"]
    data << [{content: "2", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q2')}", colspan: 2},"#{@appraisal.q2==2 ? '<b>2</b>' : '2'}","#{@appraisal.q2==1 ? '<b>1</b>' : '1'}","#{@appraisal.q2==0 ? '<b>0</b>' : 0}"]
    data << [{content: "3", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q3')}", colspan: 2},"#{@appraisal.q3==2 ? '<b>2</b>' : '2'}","#{@appraisal.q3==1 ? '<b>1</b>' : '1'}","#{@appraisal.q3==0 ? '<b>0</b>' : 0}"]
    data << [{content: "4", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q4')}", colspan: 2},"#{@appraisal.q4==2 ? '<b>2</b>' : '2'}","#{@appraisal.q4==1 ? '<b>1</b>' : '1'}","#{@appraisal.q4==0 ? '<b>0</b>' : 0}"]
    data << [{content: "5", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q5')}", colspan: 2},"#{@appraisal.q5==2 ? '<b>2</b>' : '2'}","#{@appraisal.q5==1 ? '<b>1</b>' : '1'}","#{@appraisal.q5==0 ? '<b>0</b>' : 0}"]
    data << [{content: "6", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q6')}", colspan: 2},"#{@appraisal.q6==2 ? '<b>2</b>' : '2'}","#{@appraisal.q6==1 ? '<b>1</b>' : '1'}","#{@appraisal.q6==0 ? '<b>0</b>' : 0}"]
    data << [{content: "7", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q7')}", colspan: 2},"#{@appraisal.q7==2 ? '<b>2</b>' : '2'}","#{@appraisal.q7==1 ? '<b>1</b>' : '1'}","#{@appraisal.q7==0 ? '<b>0</b>' : 0}"]
    data << [{content: "8", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q8')}", colspan: 2},"#{@appraisal.q8==2 ? '<b>2</b>' : '2'}","#{@appraisal.q8==1 ? '<b>1</b>' : '1'}","#{@appraisal.q8==0 ? '<b>0</b>' : 0}"]
    data << [{content: "9", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q9')}", colspan: 2},"#{@appraisal.q9==2 ? '<b>2</b>' : '2'}","#{@appraisal.q9==1 ? '<b>1</b>' : '1'}","#{@appraisal.q9==0 ? '<b>0</b>' : 0}"]
    data << [{content: "10", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q10')}", colspan: 2},"#{@appraisal.q10==2 ? '<b>2</b>' : '2'}","#{@appraisal.q10==1 ? '<b>1</b>' : '1'}","#{@appraisal.q10==0 ? '<b>0</b>' : 0}"]
    ###
    data << [{content: "11", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q11')}", colspan: 2},"#{@appraisal.q11==2 ? '<b>2</b>' : '2'}","#{@appraisal.q11==1 ? '<b>1</b>' : '1'}","#{@appraisal.q11==0 ? '<b>0</b>' : 0}"]
    
    data << [{content: "", colspan: 7}]
    data << [{content: "12", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q12')}", colspan: 2},"#{@appraisal.q12==2 ? '<b>2</b>' : '2'}","#{@appraisal.q12==1 ? '<b>1</b>' : '1'}","#{@appraisal.q12==0 ? '<b>0</b>' : 0}"]
    data << [{content: "13", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q13')}", colspan: 2},"#{@appraisal.q13==2 ? '<b>2</b>' : '2'}","#{@appraisal.q13==1 ? '<b>1</b>' : '1'}","#{@appraisal.q13==0 ? '<b>0</b>' : 0}"]
    data << [{content: "14", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q14')}", colspan: 2},"#{@appraisal.q14==2 ? '<b>2</b>' : '2'}","#{@appraisal.q14==1 ? '<b>1</b>' : '1'}","#{@appraisal.q14==0 ? '<b>0</b>' : 0}"]
    data << [{content: "15", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q15')}", colspan: 2},"#{@appraisal.q15==2 ? '<b>2</b>' : '2'}","#{@appraisal.q15==1 ? '<b>1</b>' : '1'}","#{@appraisal.q15==0 ? '<b>0</b>' : 0}"]
    data << [{content: "16", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q16')}", colspan: 2},"#{@appraisal.q16==2 ? '<b>2</b>' : '2'}","#{@appraisal.q16==1 ? '<b>1</b>' : '1'}","#{@appraisal.q16==0 ? '<b>0</b>' : 0}"]
    data << [{content: "17", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q17')}", colspan: 2},"#{@appraisal.q17==2 ? '<b>2</b>' : '2'}","#{@appraisal.q17==1 ? '<b>1</b>' : '1'}","#{@appraisal.q17==0 ? '<b>0</b>' : 0}"]
    data << [{content: "18", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q18')}", colspan: 2},"#{@appraisal.q18==2 ? '<b>2</b>' : '2'}","#{@appraisal.q18==1 ? '<b>1</b>' : '1'}","#{@appraisal.q18==0 ? '<b>0</b>' : 0}"]
    data << [{content: "19", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q19')}", colspan: 2},"#{@appraisal.q19==2 ? '<b>2</b>' : '2'}","#{@appraisal.q19==1 ? '<b>1</b>' : '1'}","#{@appraisal.q19==0 ? '<b>0</b>' : 0}"]
    data << [{content: "20", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q20')}", colspan: 2},"#{@appraisal.q20==2 ? '<b>2</b>' : '2'}","#{@appraisal.q20==1 ? '<b>1</b>' : '1'}","#{@appraisal.q20==0 ? '<b>0</b>' : 0}"]
    
    
    data << [{content: "21", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q21')}", colspan: 2},"#{@appraisal.q21==2 ? '<b>2</b>' : '2'}","#{@appraisal.q21==1 ? '<b>1</b>' : '1'}","#{@appraisal.q21==0 ? '<b>0</b>' : 0}"]
    data << [{content: "22", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q22')}", colspan: 2},"#{@appraisal.q22==2 ? '<b>2</b>' : '2'}","#{@appraisal.q22==1 ? '<b>1</b>' : '1'}","#{@appraisal.q22==0 ? '<b>0</b>' : 0}"]
    data << [{content: "23", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q23')}", colspan: 2},"#{@appraisal.q23==2 ? '<b>2</b>' : '2'}","#{@appraisal.q23==1 ? '<b>1</b>' : '1'}","#{@appraisal.q23==0 ? '<b>0</b>' : 0}"]
    data << [{content: "24", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q24')}", colspan: 2},"#{@appraisal.q24==2 ? '<b>2</b>' : '2'}","#{@appraisal.q24==1 ? '<b>1</b>' : '1'}","#{@appraisal.q24==0 ? '<b>0</b>' : 0}"]
    data << [{content: "25", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q25')}", colspan: 2},"#{@appraisal.q25==2 ? '<b>2</b>' : '2'}","#{@appraisal.q25==1 ? '<b>1</b>' : '1'}","#{@appraisal.q25==0 ? '<b>0</b>' : 0}"]
    data << [{content: "26", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q26')}", colspan: 2},"#{@appraisal.q26==2 ? '<b>2</b>' : '2'}","#{@appraisal.q26==1 ? '<b>1</b>' : '1'}","#{@appraisal.q26==0 ? '<b>0</b>' : 0}"]
    data << [{content: "27", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q27')}", colspan: 2},"#{@appraisal.q27==2 ? '<b>2</b>' : '2'}","#{@appraisal.q27==1 ? '<b>1</b>' : '1'}","#{@appraisal.q27==0 ? '<b>0</b>' : 0}"]
    data << [{content: "28", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q28')}", colspan: 2},"#{@appraisal.q28==2 ? '<b>2</b>' : '2'}","#{@appraisal.q28==1 ? '<b>1</b>' : '1'}","#{@appraisal.q28==0 ? '<b>0</b>' : 0}"]
    data << [{content: "29", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q29')}", colspan: 2},"#{@appraisal.q29==2 ? '<b>2</b>' : '2'}","#{@appraisal.q29==1 ? '<b>1</b>' : '1'}","#{@appraisal.q29==0 ? '<b>0</b>' : 0}"]
    data << [{content: "30", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q30')}", colspan: 2},"#{@appraisal.q30==2 ? '<b>2</b>' : '2'}","#{@appraisal.q30==1 ? '<b>1</b>' : '1'}","#{@appraisal.q30==0 ? '<b>0</b>' : 0}"]
    
    data << [{content: "31", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q31')}", colspan: 2},"#{@appraisal.q31==2 ? '<b>2</b>' : '2'}","#{@appraisal.q31==1 ? '<b>1</b>' : '1'}","#{@appraisal.q31==0 ? '<b>0</b>' : 0}"]
    data << [{content: "32", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q32')}", colspan: 2},"#{@appraisal.q32==2 ? '<b>2</b>' : '2'}","#{@appraisal.q32==1 ? '<b>1</b>' : '1'}","#{@appraisal.q32==0 ? '<b>0</b>' : 0}"]
    data << [{content: "33", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q33')}", colspan: 2},"#{@appraisal.q33==2 ? '<b>2</b>' : '2'}","#{@appraisal.q33==1 ? '<b>1</b>' : '1'}","#{@appraisal.q33==0 ? '<b>0</b>' : 0}"]
    data << [{content: "34", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q34')}", colspan: 2},"#{@appraisal.q34==2 ? '<b>2</b>' : '2'}","#{@appraisal.q34==1 ? '<b>1</b>' : '1'}","#{@appraisal.q34==0 ? '<b>0</b>' : 0}"]
    data << [{content: "35", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q35')}", colspan: 2},"#{@appraisal.q35==2 ? '<b>2</b>' : '2'}","#{@appraisal.q35==1 ? '<b>1</b>' : '1'}","#{@appraisal.q35==0 ? '<b>0</b>' : 0}"]
    data << [{content: "36", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q36')}", colspan: 2},"#{@appraisal.q36==2 ? '<b>2</b>' : '2'}","#{@appraisal.q36==1 ? '<b>1</b>' : '1'}","#{@appraisal.q36==0 ? '<b>0</b>' : 0}"]
    data << [{content: "37", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q37')}", colspan: 2},"#{@appraisal.q37==2 ? '<b>2</b>' : '2'}","#{@appraisal.q37==1 ? '<b>1</b>' : '1'}","#{@appraisal.q37==0 ? '<b>0</b>' : 0}"]
    data << [{content: "38", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q38')}", colspan: 2},"#{@appraisal.q38==2 ? '<b>2</b>' : '2'}","#{@appraisal.q38==1 ? '<b>1</b>' : '1'}","#{@appraisal.q38==0 ? '<b>0</b>' : 0}"]
    data << [{content: "39", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q39')}", colspan: 2},"#{@appraisal.q39==2 ? '<b>2</b>' : '2'}","#{@appraisal.q39==1 ? '<b>1</b>' : '1'}","#{@appraisal.q39==0 ? '<b>0</b>' : 0}"]
    data << [{content: "40", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q40')}", colspan: 2},"#{@appraisal.q40==2 ? '<b>2</b>' : '2'}","#{@appraisal.q40==1 ? '<b>1</b>' : '1'}","#{@appraisal.q40==0 ? '<b>0</b>' : 0}"]
    
    data << [{content: "41", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q41')}", colspan: 2},"#{@appraisal.q41==2 ? '<b>2</b>' : '2'}","#{@appraisal.q41==1 ? '<b>1</b>' : '1'}","#{@appraisal.q41==0 ? '<b>0</b>' : 0}"]
    data << [{content: "42", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q42')}", colspan: 2},"#{@appraisal.q42==2 ? '<b>2</b>' : '2'}","#{@appraisal.q42==1 ? '<b>1</b>' : '1'}","#{@appraisal.q42==0 ? '<b>0</b>' : 0}"]
    data << [{content: "43", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q43')}", colspan: 2},"#{@appraisal.q43==2 ? '<b>2</b>' : '2'}","#{@appraisal.q43==1 ? '<b>1</b>' : '1'}","#{@appraisal.q43==0 ? '<b>0</b>' : 0}"]
    data << [{content: "44", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q44')}", colspan: 2},"#{@appraisal.q44==2 ? '<b>2</b>' : '2'}","#{@appraisal.q44==1 ? '<b>1</b>' : '1'}","#{@appraisal.q44==0 ? '<b>0</b>' : 0}"]
    data << [{content: "45", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q45')}", colspan: 2},"#{@appraisal.q45==2 ? '<b>2</b>' : '2'}","#{@appraisal.q45==1 ? '<b>1</b>' : '1'}","#{@appraisal.q45==0 ? '<b>0</b>' : 0}"]
    data << [{content: "46", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q46')}", colspan: 2},"#{@appraisal.q46==2 ? '<b>2</b>' : '2'}","#{@appraisal.q46==1 ? '<b>1</b>' : '1'}","#{@appraisal.q46==0 ? '<b>0</b>' : 0}"]
    data << [{content: "47", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q47')}", colspan: 2},"#{@appraisal.q47==2 ? '<b>2</b>' : '2'}","#{@appraisal.q47==1 ? '<b>1</b>' : '1'}","#{@appraisal.q47==0 ? '<b>0</b>' : 0}"]
    data << [{content: "48", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q48')}", colspan: 2},"#{@appraisal.q48==2 ? '<b>2</b>' : '2'}","#{@appraisal.q48==1 ? '<b>1</b>' : '1'}","#{@appraisal.q48==0 ? '<b>0</b>' : 0}"]
    
    data << ["","","","JUMLAH", total_two, total_one, "0"]
    
    table(data, :header => true, :column_widths => [25,15, 190,185, 35, 35, 35], :cell_style => {:size=>11, :borders => [:left, :right, :top, :bottom],  :inline_format => :true, :padding=>[2,5,3,5]}) do
      a = 0
      b = 1
      row(12).height=30
      row(12).borders=[]
      row(50).column(0..2).borders=[]
      row(50).column(3).borders=[:right]
      row(50).column(4..6).borders=[:left, :right, :bottom]
      row(50).column(3).style :align => :right
      row(50).column(3..6).font_style=:bold
       
      row(0).font_style=:bold
      rows(0).background_color = 'F0F0F0'
      row(0).style :align => :center
      column(0).rows(1..49).style :align => :center
      column(4..6).rows(1..50).style :align => :center
      column(0).rows(1..49).style :valign => :center
      column(4..6).rows(1..50).style :valign => :center
      
      rowno=1
      0.upto(48).each do |cnt|
        if arr_marks[cnt]==2
          row(rowno+cnt).column(5..6).text_color = 'E5E5E5'
        elsif arr_marks[cnt]==1
          row(rowno+cnt).column(4).text_color = 'E5E5E5'
          row(rowno+cnt).column(6).text_color = 'E5E5E5'
        elsif arr_marks[cnt]==0
          row(rowno+cnt).column(4..5).text_color = 'E5E5E5'
        end
      end
      
      while a < b do
        a=+1
      end
    end
    
    move_down 30
    totalmarks=(arr_marks-[""]).sum
    data3=[["", "> 90", "80 - 65", "&lt; 64"], 
          ["SKOR<br>KESELURUHAN", "#{totalmarks if totalmarks > 80}", "#{totalmarks if totalmarks > 64 && totalmarks <=80 }", "#{totalmarks if totalmarks < 65}"]]
    table(data3, :column_widths => [100, 50, 50, 50], :cell_style => {:size=>11, :borders => [], :inline_format => :true}, :position => :center) do
      a=0
      b=1
      row(0).column(0).borders=[]
      row(0).column(1..3).borders=[:left, :right, :top]
      row(1).borders=[:left, :right, :top, :bottom]
      rows(0..1).style :align => :center
      rows(0..1).font_style = :bold
      row(1).style :valign => :center
      row(1).column(0).background_color = 'F0F0F0'
      while a < b do
        a=+1
      end
    end
    
  end
  
  def table_signatory
    data=[["TARIKH: <u>#{@appraisal.appraisal_date.try(:strftime, '%d-%m-%Y')}</u>", "TANDATANGAN: ..............................................."], ["", "Nama: <u>#{@appraisal.instructor.staff_with_rank}</u>"], ["", "Pangkat: <u>#{@appraisal.instructor.rank.name}</u>"]]
    table(data, :column_widths => [255, 255],  :cell_style => {:size=>11, :borders => [], :inline_format => :true})
  end
  
  def table_ending
    data=[["DISEDIAKAN: BKKM","#{I18n.t('exam.evaluate_course.date_updated')} : #{@appraisal.updated_at.try(:strftime, '%d-%m-%Y')} "]]
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
    draw_text "#{page_number} daripada 3",  :size => 8, :at => [230,-5]
  end
  
end
