class Studentleave_reportPdf < Prawn::Document
  def initialize(leaveforstudents, expired_wc, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :landscape })
    @leaveforstudents = leaveforstudents
    @view = view
    @expired_wc=expired_wc
    font "Times-Roman"
    text "#{college.name}", :align => :center, :size => 12, :style => :bold
    text I18n.t('student.leaveforstudent.list'), :align => :center, :size => 12, :style => :bold
    move_down 20
    record
  end
  
  def record
    expiredwc=@expired_wc
    lastrow=@leaveforstudents.count
    table(line_item_rows, :column_widths => [30,140, 60, 45, 40, 60, 45, 45, 50, 70, 60, 60, 60], :cell_style => { :size => 9,  :inline_format => :true}) do
      row(0).font_style = :bold
      #row(1).text_color = 'FA1111'
      expiredwc.each do |exp|
        row(exp).text_color = 'FA1111'
      end
      row(0).background_color = 'FFE34D'
      rows(1..lastrow).columns(4).align=:center
      rows(1..lastrow).columns(7).align=:center
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 765
      header = true
    end
  end
  
  def line_item_rows 
    header=[["No",(I18n.t 'student.leaveforstudent.student_id'), (I18n.t 'student.students.course_id'), (I18n.t 'student.leaveforstudent.intake'), (I18n.t 'student.leaveforstudent.hostel_block'), (I18n.t 'student.leaveforstudent.leavetype'), (I18n.t 'student.leaveforstudent.requestdate'), (I18n.t 'student.leaveforstudent.leaves_date'),(I18n.t 'student.leaveforstudent.studentsubmit'), (I18n.t 'student.leaveforstudent.coordinator'), (I18n.t 'student.leaveforstudent.approved'), (I18n.t 'student.leaveforstudent.warden'), (I18n.t 'student.leaveforstudent.approved')]]
    counter = counter || 0
    header +
      @leaveforstudents.map do |leaveforstudent|
      ["#{counter += 1}", "#{leaveforstudent.student_details}", "#{leaveforstudent.student.course.name} " , "#{leaveforstudent.student.intake.try(:strftime, '%b %Y')}"," #{leaveforstudent.student.tenants.last.location.root.code if !leaveforstudent.student.tenants.nil? && leaveforstudent.student.tenants.count > 0}", "#{((DropDown::STUDENTLEAVETYPE.find_all{|disp, value| value ==leaveforstudent.leavetype}).map {|disp, value| disp}).first}",  "#{leaveforstudent.requestdate.try(:strftime, '%d-%m-%y')}", "#{leaveforstudent.leave_startdate.try(:strftime, '%d-%m-%y')}"+'<br>'+"#{I18n.t('to')}"+'<br>'+"#{ leaveforstudent.leave_enddate.try(:strftime, '%d-%m-%y')}", "#{leaveforstudent.studentsubmit? ? I18n.t('submitted') : I18n.t('not_submitted')}", "#{ leaveforstudent.staff_id? ? leaveforstudent.approver_details : ''}",
       
       "#{I18n.t('approved') if leaveforstudent.approved==true} #{I18n.t('not_approved') if leaveforstudent.studentsubmit==true && leaveforstudent.leave_startdate >= Date.tomorrow && (leaveforstudent.approved==false || leaveforstudent.approved==nil)} #{I18n.t('student.leaveforstudent.expired') if leaveforstudent.studentsubmit==true && leaveforstudent.leave_startdate < Date.tomorrow && leaveforstudent.approved==nil }", "#{ leaveforstudent.staff_id2? ? leaveforstudent.approver_details2 : ''}",
       
       "#{I18n.t('approved') if leaveforstudent.approved2==true} #{I18n.t('not_approved') if leaveforstudent.studentsubmit==true && leaveforstudent.leave_startdate >= Date.tomorrow && (leaveforstudent.approved2==false || leaveforstudent.approved2==nil)} #{I18n.t('student.leaveforstudent.expired') if leaveforstudent.studentsubmit==true && leaveforstudent.leave_startdate < Date.tomorrow && leaveforstudent.approved2==nil }"]
    end
  end
end