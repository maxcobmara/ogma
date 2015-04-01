class Kumpulan_etnikPdf < Prawn::Document
  def initialize(student, view, programme_id, students_6intakes_ids, valid, prepared_by)
    super({top_margin: 15,bottom_margin: 10,left_margin: 10, page_size: 'A4', page_layout: :landscape })
    @student = student
    @programme_id = programme_id
    @students_6intakes_ids = students_6intakes_ids
    @valid = valid
    @view = view
    @prepared_by=prepared_by
    font "Times-Roman"
    image "#{Rails.root}/app/assets/images/logo_kerajaan.png", :position => :center, :scale => 0.45
    move_down 5
    text "BAHAGIAN PENGURUSAN LATIHAN", :align => :center, :size => 11, :style => :bold
    text "KEMENTERIAN KESIHATAN MALAYSIA", :align => :center, :size => 11, :style => :bold
    move_down 5
    text "MAKLUMAT KUMPULAN ETNIK PELATIH DI INSTITUSI LATIHAN KEMENTERIAN KESIHATAN MALAYSIA", :align => :center, :size => 11, :style => :italic
    move_down 5
    if Date.today.month < 7
    text "INSTITUSI LATIHAN : KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU                                                                      **SESI:JAN-JUN #{Date.today.year}  JUL-DIS.......", :align => :left, :size => 11, :style => :bold
    else
    text "INSTITUSI LATIHAN : KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU                                                                      **SESI:JAN-JUN......  JUL-DIS #{Date.today.year}", :align => :left, :size => 11, :style => :bold
    end
    move_down 5
    kumpulan_tajuk
    kumpulan_data
    move_down 5
    cop
    #text "aaaa", :rotate => 90
  end
  
  
  def kumpulan_tajuk
    
    data = [["", "", "", "KUMPULAN ETNIK",""]]
    
    table(data, :column_widths => [75, 45, 34, 624, ], :cell_style => { :size => 8, :inline_format => :true}) do
      columns(3).align = :center
      row(0).background_color = 'FFE34D'
      row(0).column(0).borders = [:left, :right, :top]
      row(0).column(1).borders = [:left, :right, :top]
      row(0).column(2).borders = [:left, :right, :top]
      row(0).column(4).borders = [:left, :right, :top]
      self.width = 820
    end
  end
  
  def kumpulan_data
    #Year 1
    @t1s1a=Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 1).count
    @t1s1b=Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 2).count
    @t1s1c=Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 3).count
    @t1s1d=Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 4).count
    @t1s1e=Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 5).count
    @t1s1f=Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 6).count
    @t1s1g=Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 7).count
    @t1s1h=Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 8).count
    @t1s1i=Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 9).count
    @t1s1j=Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 10).count
    @t1s1k=Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 11).count
    @t1s1l=Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 12).count
    @t1s1m=Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 13).count
    @t1s1n=Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 14).count
    @t1s1o=Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 15).count
    @t1s1p=Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 16).count
    @t1s1q=Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 17).count
    @t1s1r=Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 18).count
    @t1s1s=Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 19).count
    @t1s1t=Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 20).count
    @t1s1u=Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 21).count
    @total_t1s1=Student.get_student_by_intake_gender(1, 1, 2,@programme_id).count
    
    #Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 1).count
    @m_t1s1a=Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 1).count
    @m_t1s1b=Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 2).count
    @m_t1s1c=Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 3).count
    @m_t1s1d=Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 4).count
    @m_t1s1e=Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 5).count
    @m_t1s1f=Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 6).count
    @m_t1s1g=Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 7).count
    @m_t1s1h=Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 8).count
    @m_t1s1i=Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 9).count
    @m_t1s1j=Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 10).count
    @m_t1s1k=Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 11).count
    @m_t1s1l=Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 12).count
    @m_t1s1m=Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 13).count
    @m_t1s1n=Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 14).count
    @m_t1s1o=Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 15).count
    @m_t1s1p=Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 16).count
    @m_t1s1q=Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 17).count
    @m_t1s1r=Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 18).count
    @m_t1s1s=Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 19).count
    @m_t1s1t=Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 20).count
    @m_t1s1u=Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 21).count
    @m_total_t1s1=Student.get_student_by_intake_gender(1, 1, 1,@programme_id).count
    
    #Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 1).count
    @t1s2a=Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 1).count
    @t1s2b=Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 2).count
    @t1s2c=Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 3).count
    @t1s2d=Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 4).count
    @t1s2e=Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 5).count
    @t1s2f=Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 6).count
    @t1s2g=Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 7).count
    @t1s2h=Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 8).count
    @t1s2i=Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 9).count
    @t1s2j=Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 10).count
    @t1s2k=Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 11).count
    @t1s2l=Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 12).count
    @t1s2m=Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 13).count
    @t1s2n=Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 14).count
    @t1s2o=Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 15).count
    @t1s2p=Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 16).count
    @t1s2q=Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 17).count
    @t1s2r=Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 18).count
    @t1s2s=Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 19).count
    @t1s2t=Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 20).count
    @t1s2u=Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 21).count
    @total_t1s2=Student.get_student_by_intake_gender(2, 1, 2,@programme_id).count
    
    #Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 1).count
    @m_t1s2a=Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 1).count
    @m_t1s2b=Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 2).count
    @m_t1s2c=Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 3).count
    @m_t1s2d=Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 4).count
    @m_t1s2e=Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 5).count
    @m_t1s2f=Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 6).count
    @m_t1s2g=Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 7).count
    @m_t1s2h=Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 8).count
    @m_t1s2i=Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 9).count
    @m_t1s2j=Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 10).count
    @m_t1s2k=Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 11).count
    @m_t1s2l=Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 12).count
    @m_t1s2m=Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 13).count
    @m_t1s2n=Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 14).count
    @m_t1s2o=Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 15).count
    @m_t1s2p=Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 16).count
    @m_t1s2q=Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 17).count
    @m_t1s2r=Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 18).count
    @m_t1s2s=Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 19).count
    @m_t1s2t=Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 20).count
    @m_t1s2u=Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 21).count
    @m_total_t1s2=Student.get_student_by_intake_gender(2, 1, 1,@programme_id).count
    
    ###Year 2
    @t2s1a=Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 1).count
    @t2s1b=Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 2).count
    @t2s1c=Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 3).count
    @t2s1d=Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 4).count
    @t2s1e=Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 5).count
    @t2s1f=Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 6).count
    @t2s1g=Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 7).count
    @t2s1h=Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 8).count
    @t2s1i=Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 9).count
    @t2s1j=Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 10).count
    @t2s1k=Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 11).count
    @t2s1l=Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 12).count
    @t2s1m=Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 13).count
    @t2s1n=Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 14).count
    @t2s1o=Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 15).count
    @t2s1p=Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 16).count
    @t2s1q=Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 17).count
    @t2s1r=Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 18).count
    @t2s1s=Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 19).count
    @t2s1t=Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 20).count
    @t2s1u=Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 21).count
    @total_t2s1=Student.get_student_by_intake_gender(1, 2, 2,@programme_id).count
    
    @m_t2s1a=Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 1).count
    @m_t2s1b=Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 2).count
    @m_t2s1c=Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 3).count
    @m_t2s1d=Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 4).count
    @m_t2s1e=Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 5).count
    @m_t2s1f=Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 6).count
    @m_t2s1g=Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 7).count
    @m_t2s1h=Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 8).count
    @m_t2s1i=Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 9).count
    @m_t2s1j=Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 10).count
    @m_t2s1k=Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 11).count
    @m_t2s1l=Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 12).count
    @m_t2s1m=Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 13).count
    @m_t2s1n=Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 14).count
    @m_t2s1o=Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 15).count
    @m_t2s1p=Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 16).count
    @m_t2s1q=Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 17).count
    @m_t2s1r=Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 18).count
    @m_t2s1s=Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 19).count
    @m_t2s1t=Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 20).count
    @m_t2s1u=Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 21).count
    @m_total_t2s1=Student.get_student_by_intake_gender(1, 2, 1,@programme_id).count
    
    @t2s2a=Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 1).count
    @t2s2b=Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 2).count
    @t2s2c=Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 3).count
    @t2s2d=Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 4).count
    @t2s2e=Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 5).count
    @t2s2f=Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 6).count
    @t2s2g=Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 7).count
    @t2s2h=Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 8).count
    @t2s2i=Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 9).count
    @t2s2j=Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 10).count
    @t2s2k=Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 11).count
    @t2s2l=Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 12).count
    @t2s2m=Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 13).count
    @t2s2n=Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 14).count
    @t2s2o=Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 15).count
    @t2s2p=Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 16).count
    @t2s2q=Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 17).count
    @t2s2r=Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 18).count
    @t2s2s=Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 19).count
    @t2s2t=Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 20).count
    @t2s2u=Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 21).count
    @total_t2s2=Student.get_student_by_intake_gender(2, 2, 2,@programme_id).count
    
    @m_t2s2a=Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 1).count
    @m_t2s2b=Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 2).count
    @m_t2s2c=Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 3).count
    @m_t2s2d=Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 4).count
    @m_t2s2e=Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 5).count
    @m_t2s2f=Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 6).count
    @m_t2s2g=Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 7).count
    @m_t2s2h=Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 8).count
    @m_t2s2i=Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 9).count
    @m_t2s2j=Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 10).count
    @m_t2s2k=Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 11).count
    @m_t2s2l=Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 12).count
    @m_t2s2m=Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 13).count
    @m_t2s2n=Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 14).count
    @m_t2s2o=Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 15).count
    @m_t2s2p=Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 16).count
    @m_t2s2q=Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 17).count
    @m_t2s2r=Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 18).count
    @m_t2s2s=Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 19).count
    @m_t2s2t=Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 20).count
    @m_t2s2u=Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 21).count
    @m_total_t2s2=Student.get_student_by_intake_gender(2, 2, 1,@programme_id).count
    
    ###
    ###Year 3
    @t3s1a=Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 1).count
    @t3s1b=Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 2).count
    @t3s1c=Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 3).count
    @t3s1d=Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 4).count
    @t3s1e=Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 5).count
    @t3s1f=Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 6).count
    @t3s1g=Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 7).count
    @t3s1h=Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 8).count
    @t3s1i=Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 9).count
    @t3s1j=Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 10).count
    @t3s1k=Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 11).count
    @t3s1l=Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 12).count
    @t3s1m=Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 13).count
    @t3s1n=Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 14).count
    @t3s1o=Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 15).count
    @t3s1p=Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 16).count
    @t3s1q=Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 17).count
    @t3s1r=Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 18).count
    @t3s1s=Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 19).count
    @t3s1t=Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 20).count
    @t3s1u=Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 21).count
    @total_t3s1=Student.get_student_by_intake_gender(1, 3, 2,@programme_id).count
    
    @m_t3s1a=Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 1).count
    @m_t3s1b=Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 2).count
    @m_t3s1c=Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 3).count
    @m_t3s1d=Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 4).count
    @m_t3s1e=Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 5).count
    @m_t3s1f=Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 6).count
    @m_t3s1g=Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 7).count
    @m_t3s1h=Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 8).count
    @m_t3s1i=Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 9).count
    @m_t3s1j=Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 10).count
    @m_t3s1k=Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 11).count
    @m_t3s1l=Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 12).count
    @m_t3s1m=Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 13).count
    @m_t3s1n=Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 14).count
    @m_t3s1o=Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 15).count
    @m_t3s1p=Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 16).count
    @m_t3s1q=Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 17).count
    @m_t3s1r=Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 18).count
    @m_t3s1s=Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 19).count
    @m_t3s1t=Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 20).count
    @m_t3s1u=Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 21).count
    @m_total_t3s1=Student.get_student_by_intake_gender(1, 3, 1,@programme_id).count
    
    @t3s2a=Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 1).count
    @t3s2b=Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 2).count
    @t3s2c=Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 3).count
    @t3s2d=Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 4).count
    @t3s2e=Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 5).count
    @t3s2f=Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 6).count
    @t3s2g=Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 7).count
    @t3s2h=Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 8).count
    @t3s2i=Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 9).count
    @t3s2j=Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 10).count
    @t3s2k=Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 11).count
    @t3s2l=Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 12).count
    @t3s2m=Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 13).count
    @t3s2n=Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 14).count
    @t3s2o=Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 15).count
    @t3s2p=Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 16).count
    @t3s2q=Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 17).count
    @t3s2r=Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 18).count
    @t3s2s=Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 19).count
    @t3s2t=Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 20).count
    @t3s2u=Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 21).count
    @total_t3s2=Student.get_student_by_intake_gender(2, 3, 2,@programme_id).count
    
    @m_t3s2a=Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 1).count
    @m_t3s2b=Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 2).count
    @m_t3s2c=Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 3).count
    @m_t3s2d=Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 4).count
    @m_t3s2e=Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 5).count
    @m_t3s2f=Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 6).count
    @m_t3s2g=Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 7).count
    @m_t3s2h=Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 8).count
    @m_t3s2i=Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 9).count
    @m_t3s2j=Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 10).count
    @m_t3s2k=Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 11).count
    @m_t3s2l=Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 12).count
    @m_t3s2m=Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 13).count
    @m_t3s2n=Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 14).count
    @m_t3s2o=Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 15).count
    @m_t3s2p=Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 16).count
    @m_t3s2q=Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 17).count
    @m_t3s2r=Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 18).count
    @m_t3s2s=Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 19).count
    @m_t3s2t=Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 20).count
    @m_t3s2u=Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 21).count
    @m_total_t3s2=Student.get_student_by_intake_gender(2, 3, 1,@programme_id).count
    ###
    
    data = [["JENIS PROGRAM/ KURSUS","KUMP","Jantina", "Melayu","Cina","India","Org Asli","Bajau","Murut","Brunei","Bisaya","Kadazan","Suluk","Kedayan","Iban","Kadazan Dusun","Sungai","Siam","Malanau","Bugis","Bidayuh","Momogun Rungus","Dusun","Lain-lain","JUMLAH"],
            [{content: "#{Programme.find(@programme_id).programme_list}", rowspan: 12},"T1SI","P","#{@t1s1a if @t1s1a>0}","#{@t1s1b if @t1s1b>0}","#{@t1s1c if @t1s1c>0}","#{@t1s1d if @t1s1d>0}","#{@t1s1e if @t1s1e>0}","#{@t1s1f if @t1s1f>0}","#{@t1s1g if @t1s1g>0}","#{@t1s1h if @t1s1h>0}","#{@t1s1i if @t1s1i>0}","#{@t1s1j if @t1s1j>0}","#{@t1s1k if @t1s1k>0}","#{@t1s1l if @t1s1l>0}","#{@t1s1m if @t1s1m>0}","#{@t1s1n if @t1s1n>0}","#{@t1s1o if @t1s1o>0}","#{@t1s1p if @t1s1p>0}","#{@t1s1q if @t1s1q>0}","#{@t1s1r if @t1s1r>0}","#{@t1s1s if @t1s1s>0}","#{@t1s1t if @t1s1t>0}","#{@t1s1u if @t1s1u>0}","#{@total_t1s1 if @total_t1s1>0}"],
            ["","L","#{@m_t1s1a if @m_t1s1a>0}","#{@m_t1s1b if @m_t1s1b>0}","#{@m_t1s1c if @m_t1s1c>0}","#{@m_t1s1d if @m_t1s1d>0}","#{@m_t1s1e if @m_t1s1e>0}","#{@m_t1s1f if @m_t1s1f>0}","#{@m_t1s1g if @m_t1s1g>0}","#{@m_t1s1h if @m_t1s1h>0}","#{@m_t1s1i if @m_t1s1i>0}","#{@m_t1s1j if @m_t1s1j>0}","#{@m_t1s1k if @m_t1s1k>0}","#{@m_t1s1l if @m_t1s1l>0}","#{@m_t1s1m if @m_t1s1m>0}","#{@m_t1s1n if @m_t1s1n>0}","#{@m_t1s1o if @m_t1s1o>0}","#{@m_t1s1p if @m_t1s1p>0}","#{@m_t1s1q if @m_t1s1q>0}","#{@m_t1s1r if @m_t1s1r>0}","#{@m_t1s1s if @m_t1s1s>0}","#{@m_t1s1t if @m_t1s1t>0}","#{@m_t1s1u if @m_t1s1u>0}","#{@m_total_t1s1 if @m_total_t1s1>0}"],
            ["T1SII","P","#{@t1s2a if @t1s2a>0}","#{@t1s2b if @t1s2b>0}","#{@t1s2c if @t1s2c>0}","#{@t1s2d if @t1s2d>0}","#{@t1s2e if @t1s2e>0}","#{@t1s2f if @t1s2f>0}","#{@t1s2g if @t1s2g>0}","#{@t1s2h if @t1s2h>0}","#{@t1s2i if @t1s2i>0}","#{@t1s2j if @t1s2j>0}","#{@t1s2k if @t1s2k>0}","#{@t1s2l if @t1s2l>0}","#{@t1s2m if @t1s2m>0}","#{@t1s2n if @t1s2n>0}","#{@t1s2o if @t1s2o>0}","#{@t1s2p if @t1s2p>0}","#{@t1s2q if @t1s2q>0}","#{@t1s2r if @t1s2r>0}","#{@t1s2s if @t1s2s>0}","#{@t1s2t if @t1s2t>0}","#{@t1s2u if @t1s2u>0}","#{@total_t1s2 if @total_t1s2>0}"],
            ["","L","#{@m_t1s2a if @m_t1s2a>0}","#{@m_t1s2b if @m_t1s2b>0}","#{@m_t1s2c if @m_t1s2c>0}","#{@m_t1s2d if @m_t1s2d>0}","#{@m_t1s2e if @m_t1s2e>0}","#{@m_t1s2f if @m_t1s2f>0}","#{@m_t1s2g if @m_t1s2g>0}","#{@m_t1s2h if @m_t1s2h>0}","#{@m_t1s2i if @m_t1s2i>0}","#{@m_t1s2j if @m_t1s2j>0}","#{@m_t1s2k if @m_t1s2k>0}","#{@m_t1s2l if @m_t1s2l>0}","#{@m_t1s2m if @m_t1s2m>0}","#{@m_t1s2n if @m_t1s2n>0}","#{@m_t1s2o if @m_t1s2o>0}","#{@m_t1s2p if @m_t1s2p>0}","#{@m_t1s2q if @m_t1s2q>0}","#{@m_t1s2r if @m_t1s2r>0}","#{@m_t1s2s if @m_t1s2s>0}","#{@m_t1s2t if @m_t1s2t>0}","#{@m_t1s2u if @m_t1s2u>0}","#{@m_total_t1s2 if @m_total_t1s2>0}"],
            ["T2SI","P","#{@t2s1a if @t2s1a>0}","#{@t2s1b if @t2s1b>0}","#{@t2s1c if @t2s1c>0}","#{@t2s1d if @t2s1d>0}","#{@t2s1e if @t2s1e>0}","#{@t2s1f if @t2s1f>0}","#{@t2s1g if @t2s1g>0}","#{@t2s1h if @t2s1h>0}","#{@t2s1i if @t2s1i>0}","#{@t2s1j if @t2s1j>0}","#{@t2s1k if @t2s1k>0}","#{@t2s1l if @t2s1l>0}","#{@t2s1m if @t2s1m>0}","#{@t2s1n if @t2s1n>0}","#{@t2s1o if @t2s1o>0}","#{@t2s1p if @t2s1p>0}","#{@t2s1q if @t2s1q>0}","#{@t2s1r if @t2s1r>0}","#{@t2s1s if @t2s1s>0}","#{@t2s1t if @t2s1t>0}","#{@t2s1u if @t2s1u>0}","#{@total_t2s1 if @total_t2s1>0}"],
            ["","L","#{@m_t2s1a if @m_t2s1a>0}","#{@m_t2s1b if @m_t2s1b>0}","#{@m_t2s1c if @m_t2s1c>0}","#{@m_t2s1d if @m_t2s1d>0}","#{@m_t2s1e if @m_t2s1e>0}","#{@m_t2s1f if @m_t2s1f>0}","#{@m_t2s1g if @m_t2s1g>0}","#{@m_t2s1h if @m_t2s1h>0}","#{@m_t2s1i if @m_t2s1i>0}","#{@m_t2s1j if @m_t2s1j>0}","#{@m_t2s1k if @m_t2s1k>0}","#{@m_t2s1l if @m_t2s1l>0}","#{@m_t2s1m if @m_t2s1m>0}","#{@m_t2s1n if @m_t2s1n>0}","#{@m_t2s1o if @m_t2s1o>0}","#{@m_t2s1p if @m_t2s1p>0}","#{@m_t2s1q if @m_t2s1q>0}","#{@m_t2s1r if @m_t2s1r>0}","#{@m_t2s1s if @m_t2s1s>0}","#{@m_t2s1t if @m_t2s1t>0}","#{@m_t2s1u if @m_t2s1u>0}","#{@m_total_t2s1 if @m_total_t2s1>0}"],
            ["T2SII","P","#{@t2s2a if @t2s2a>0}","#{@t2s2b if @t2s2b>0}","#{@t2s2c if @t2s2c>0}","#{@t2s2d if @t2s2d>0}","#{@t2s2e if @t2s2e>0}","#{@t2s2f if @t2s2f>0}","#{@t2s2g if @t2s2g>0}","#{@t2s2h if @t2s2h>0}","#{@t2s2i if @t2s2i>0}","#{@t2s2j if @t2s2j>0}","#{@t2s2k if @t2s2k>0}","#{@t2s2l if @t2s2l>0}","#{@t2s2m if @t2s2m>0}","#{@t2s2n if @t2s2n>0}","#{@t2s2o if @t2s2o>0}","#{@t2s2p if @t2s2p>0}","#{@t2s2q if @t2s2q>0}","#{@t2s2r if @t2s2r>0}","#{@t2s2s if @t2s2s>0}","#{@t2s2t if @t2s2t>0}","#{@t2s2u if @t2s2u>0}","#{@total_t2s2 if @total_t2s2>0}"],
            ["","L","#{@m_t2s2a if @m_t2s2a>0}","#{@m_t2s2b if @m_t2s2b>0}","#{@m_t2s2c if @m_t2s2c>0}","#{@m_t2s2d if @m_t2s2d>0}","#{@m_t2s2e if @m_t2s2e>0}","#{@m_t2s2f if @m_t2s2f>0}","#{@m_t2s2g if @m_t2s2g>0}","#{@m_t2s2h if @m_t2s2h>0}","#{@m_t2s2i if @m_t2s2i>0}","#{@m_t2s2j if @m_t2s2j>0}","#{@m_t2s2k if @m_t2s2k>0}","#{@m_t2s2l if @m_t2s2l>0}","#{@m_t2s2m if @m_t2s2m>0}","#{@m_t2s2n if @m_t2s2n>0}","#{@m_t2s2o if @m_t2s2o>0}","#{@m_t2s2p if @m_t2s2p>0}","#{@m_t2s2q if @m_t2s2q>0}","#{@m_t2s2r if @m_t2s2r>0}","#{@m_t2s2s if @m_t2s2s>0}","#{@m_t2s2t if @m_t2s2t>0}","#{@m_t2s2u if @m_t2s2u>0}","#{@m_total_t2s2 if @m_total_t2s2>0}"],
            ["T3SI","P","#{@t3s1a if @t3s1a>0}","#{@t3s1b if @t3s1b>0}","#{@t3s1c if @t3s1c>0}","#{@t3s1d if @t3s1d>0}","#{@t3s1e if @t3s1e>0}","#{@t3s1f if @t3s1f>0}","#{@t3s1g if @t3s1g>0}","#{@t3s1h if @t3s1h>0}","#{@t3s1i if @t3s1i>0}","#{@t3s1j if @t3s1j>0}","#{@t3s1k if @t3s1k>0}","#{@t3s1l if @t3s1l>0}","#{@t3s1m if @t3s1m>0}","#{@t3s1n if @t3s1n>0}","#{@t3s1o if @t3s1o>0}","#{@t3s1p if @t3s1p>0}","#{@t3s1q if @t3s1q>0}","#{@t3s1r if @t3s1r>0}","#{@t3s1s if @t3s1s>0}","#{@t3s1t if @t3s1t>0}","#{@t3s1u if @t3s1u>0}","#{@total_t3s1 if @total_t3s1>0}"],
            ["","L","#{@m_t3s1a if @m_t3s1a>0}","#{@m_t3s1b if @m_t3s1b>0}","#{@m_t3s1c if @m_t3s1c>0}","#{@m_t3s1d if @m_t3s1d>0}","#{@m_t3s1e if @m_t3s1e>0}","#{@m_t3s1f if @m_t3s1f>0}","#{@m_t3s1g if @m_t3s1g>0}","#{@m_t3s1h if @m_t3s1h>0}","#{@m_t3s1i if @m_t3s1i>0}","#{@m_t3s1j if @m_t3s1j>0}","#{@m_t3s1k if @m_t3s1k>0}","#{@m_t3s1l if @m_t3s1l>0}","#{@m_t3s1m if @m_t3s1m>0}","#{@m_t3s1n if @m_t3s1n>0}","#{@m_t3s1o if @m_t3s1o>0}","#{@m_t3s1p if @m_t3s1p>0}","#{@m_t3s1q if @m_t3s1q>0}","#{@m_t3s1r if @m_t3s1r>0}","#{@m_t3s1s if @m_t3s1s>0}","#{@m_t3s1t if @m_t3s1t>0}","#{@m_t3s1u if @m_t3s1u>0}","#{@m_total_t3s1 if @m_total_t3s1>0}"],
            ["T3SII","P","#{@t3s2a if @t3s2a>0}","#{@t3s2b if @t3s2b>0}","#{@t3s2c if @t3s2c>0}","#{@t3s2d if @t3s2d>0}","#{@t3s2e if @t3s2e>0}","#{@t3s2f if @t3s2f>0}","#{@t3s2g if @t3s2g>0}","#{@t3s2h if @t3s2h>0}","#{@t3s2i if @t3s2i>0}","#{@t3s2j if @t3s2j>0}","#{@t3s2k if @t3s2k>0}","#{@t3s2l if @t3s2l>0}","#{@t3s2m if @t3s2m>0}","#{@t3s2n if @t3s2n>0}","#{@t3s2o if @t3s2o>0}","#{@t3s2p if @t3s2p>0}","#{@t3s2q if @t3s2q>0}","#{@t3s2r if @t3s2r>0}","#{@t3s2s if @t3s2s>0}","#{@t3s2t if @t3s2t>0}","#{@t3s2u if @t3s2u>0}","#{@total_t3s2 if @total_t3s2>0}"],
            ["","L","#{@m_t3s2a if @m_t3s2a>0}","#{@m_t3s2b if @m_t3s2b>0}","#{@m_t3s2c if @m_t3s2c>0}","#{@m_t3s2d if @m_t3s2d>0}","#{@m_t3s2e if @m_t3s2e>0}","#{@m_t3s2f if @m_t3s2f>0}","#{@m_t3s2g if @m_t3s2g>0}","#{@m_t3s2h if @m_t3s2h>0}","#{@m_t3s2i if @m_t3s2i>0}","#{@m_t3s2j if @m_t3s2j>0}","#{@m_t3s2k if @m_t3s2k>0}","#{@m_t3s2l if @m_t3s2l>0}","#{@m_t3s2m if @m_t3s2m>0}","#{@m_t3s2n if @m_t3s2n>0}","#{@m_t3s2o if @m_t3s2o>0}","#{@m_t3s2p if @m_t3s2p>0}","#{@m_t3s2q if @m_t3s2q>0}","#{@m_t3s2r if @m_t3s2r>0}","#{@m_t3s2s if @m_t3s2s>0}","#{@m_t3s2t if @m_t3s2t>0}","#{@m_t3s2u if @m_t3s2u>0}","#{@m_total_t3s2 if @m_total_t3s2>0}"],
            ["","JUMLAH"," ","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 1,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 2,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 3,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 4,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 5,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 6,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 7,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 8,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 9,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 10,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 11,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 12,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 13,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 14,@students_6intakes_ids).count}",
              "#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 15,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 16,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 17,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 18,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 19,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 20,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 21,@students_6intakes_ids).count}","#{@valid.count}"]]
            
            table(data, :column_widths => [75, 45, 34, 34, 25, 27,25,30,30,32,32,32,28,38,25,38,32,28,30,28,25,35,25,25], :cell_style => { :size => 8}) do
              a = 1
              b = 13
              columns(0).align = :center
              row(0).background_color = 'FFE34D'
              row(0).column(0).borders = [:left, :right, :bottom]
              row(0).column(1).borders = [:left, :right, :bottom]
              row(0).column(2).borders = [:left, :right, :bottom]
              row(0).column(24).borders = [:left, :right, :bottom]
              while a < b do
              row(a).column(0).borders = [:left, :right]
              a += 1
            end
              self.width = 820
            end
end

  def cop
    text "* P - Perempuan", :align => :left, :size => 10, :indent_paragraphs => 30
    text "* L - Lelaki", :align => :left, :size => 10, :indent_paragraphs => 30
    
    data=[["","Disediakan oleh :","","Disahkan oleh :"],
               ["","", "",""],
               ["","Nama :  #{@prepared_by.name}","","Pengarah"],
               ["","Jawatan :  #{@prepared_by.try(:position_for_staff)} #{@prepared_by.try(:grade_for_staff)}","",""]]
    table(data, :column_widths => [25, 250, 300, 150], :cell_style => { :size => 10, :borders => []})  do
              a = 0
              b = 4
              column(0..1).font_style = :normal
	      row(1).height = 25
	      rows(1).columns(1).borders=[:bottom]
	      rows(1).columns(3).borders=[:bottom]
	      row(0).height = 18
	      row(2..3).height =18
              while a < b do
              a += 1
            end
    end
    move_down 10
    text "Catatan : ", :align => :left, :size => 10, :indent_paragraphs => 30
    text "* Laporan setiap 6 bulan pada 15 Februari & 15 Ogos", :align => :left, :size => 10, :indent_paragraphs => 30
  end
  
end