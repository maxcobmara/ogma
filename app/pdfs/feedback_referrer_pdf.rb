class Feedback_referrerPdf < Prawn::Document 
  def initialize(sessions, view, case_details)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @sessions_by_case  = sessions
    @view = view
    @case_details = case_details
    @intake=@case_details.student.intake
    font "Times-Roman"
    move_down 20
    text "MAKLUM BALAS KAUNSELING BAGI KES RUJUKAN", :align => :center, :size => 12, :style => :bold
    move_down 10
    text "BUTIRAN KES", :align=>:left, :size => 11, :style => :bold
    move_down 10
    table_case
    move_down 15
    table_tphep_actions
    move_down 20
    text "BUTIRAN SESI KAUNSELING", :align=>:left, :size => 11, :style => :bold
    move_down 10
    table_sessions
    move_down 5
    table_final_feedback 
  end

  def table_case
    data=[["Nama Pelajar","#{@case_details.student.name}","Pelapor Kes","#{@case_details.staff.staff_with_rank}"],
          ["No Matrik","#{@case_details.student.matrixno}","Ambilan","#{@case_details.student_id.blank? ? "" : @case_details.student.try(:intake).try(:strftime,"%B %Y")}"],
          ["Program","#{@case_details.student.try(:course).try(:programme_list)}","Tahun/Semester","#{Student.year_and_sem(@intake)}"],
          ["Kesalahan","#{(DropDown::INFRACTION.find_all{|disp, value| value == @case_details.infraction_id}).map {|disp, value| disp}[0]}","Lokasi Kes","#{@case_details.location.try(:location_list)}"],
          ["Tarikh & Masa","#{@case_details.reported_on.try(:strftime, "%d %b %y, %l:%M %P")}","Jenis Tindakan","#{"Kaunseling" if @case_details.action_type='counseling'}"]]
    table(data, :column_widths => [100, 190, 90, 130], :cell_style => { :size => 11, :borders => [:left, :right, :top, :bottom]})  do
              a = 0
              b = 5
              column(0).font_style = :bold
              column(0).background_color = 'ABA9A9'
              column(2).font_style = :bold
              column(2).background_color = 'ABA9A9'
              while a < b do
              a += 1
            end
    end
  end
  
  def table_tphep_actions
    data=[["Tindakan oleh TPHEP","#{@case_details.action}"]]
    table(data, :column_widths => [180,330], :cell_style => {:size=>11, :borders => [:left, :right, :top, :bottom]}) do
      a = 0
      b = 1
      column(0).font_style = :bold
      column(0).background_color = 'ABA9A9'
      while a < b do
        a=+1
      end
    end
  end
  
  def table_sessions
     for session in @sessions_by_case 
       data=[["Tarikh & Masa","#{session.confirmed_at.try(:strftime, "%d %b %y, %l:%M %P")}", "Skop Sesi", "#{session.c_scope if !session.c_scope.blank?}"],["Tempoh Sesi","#{session.duration}","Jenis Sesi","#{session.c_type}"],["Deskripsi Isu",{content: "#{session.issue_desc}", colspan: 3}],["Nota Sesi",{content: "#{session.notes}", colspan: 3}],["Maklumbalas Kaunselor (bagi sesi ini)",{content: "#{session.remark}", colspan: 3}]]
       table(data, :column_widths => [100, 190, 90, 130], :cell_style=>{:size=>11, :borders=>[:left, :right, :top, :bottom]}) do
	 a=0
	 b=5
	 column(0).font_style = :bold
	 column(0).background_color = 'ABA9A9'
	 column(2).font_style = :bold
	 cells[0,2].background_color = 'ABA9A9'
	 cells[1,2].background_color = 'ABA9A9'  
	 while a < b do
	   a+=1  
	 end
       end
       move_down 15
     end
  end
  
  def table_final_feedback
    data=[["Maklumbalas Akhir oleh Kaunselor (bagi kesemua sesi di atas)","#{@case_details.counselor_feedback}"]]
    table(data, :column_widths => [180, 330], :cell_style => {:size=>11, :borders => [:left, :right, :top, :bottom]}) do
      a = 0
      b = 1
      column(0).font_style = :bold
      column(0).background_color = 'ABA9A9'
      while a < b do
        a=+1
      end
    end
  end
  
  
end