class Leaveforstaff_listPdf < Prawn::Document
  def initialize(leaveforstaffs, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @leaveforstaffs = leaveforstaffs
    @view = view
    @college=college
    font "Helvetica"
    record
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  def record
    groupped_leaves=@leaveforstaffs.group_by(&:applicant)
    if groupped_leaves.count > 1
      columnswidth=[30, 100, 60, 60, 80, 80, 130]
      row_counts=[]
      rowno=2
      recs_per_applicant=0
      groupped_leaves.each do |applicant, leaveforstaffs|
          row_counts << rowno+recs_per_applicant
          recs_per_applicant+=leaveforstaffs.count+1
      end
    else
      columnswidth=[30, 90, 80, 60, 50, 70, 60, 100]
    end
    
    table(line_item_rows, :column_widths => columnswidth, :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      if groupped_leaves.count > 1
        for row_count in row_counts
          row(row_count).font_style=:bold
	  row(row_count).align =:center
	  row(row_count).background_color='FDF8A1'
        end
      end
      self.width=540
    end
  end
    
  def line_item_rows
    groupped_leaves=@leaveforstaffs.group_by(&:applicant)
    if groupped_leaves.count > 1
      colcount=7
    else
      colcount=8
    end
    counter = counter || 0
    header = [[{content: "#{I18n.t('staff_leave.list').upcase}<br> #{@college.name.upcase}", colspan: colcount}]]
    if groupped_leaves.count == 1
      header_title=["No", "#{@college.code=='kskbjb' ? I18n.t('staff_leave.id') : I18n.t('staff_leave.staff_id')}"]
    else
      header_title=["No"]
    end
    header_title +=[I18n.t('staff_leave.leavetype'), "#{I18n.t('staff_leave.from')} / #{I18n.t('staff_leave.to')}", I18n.t('staff_leave.duration'), "#{I18n.t('staff_leave.supported')} ?", "#{I18n.t('staff_leave.approved')} ?", I18n.t('staff_leave.replacement')]
    body=[]
    groupped_leaves.each do |applicant, leaveforstaffs|
        if groupped_leaves.count > 1
          body << [{content: applicant.staff_with_rank, colspan: 7}]
        end
        for leaveforstaff in leaveforstaffs
	    leavetype=(DropDown::STAFFLEAVETYPE.find_all{|disp, value| value == leaveforstaff.leavetype}).map {|disp, value| disp} [0]
	    start_end="#{leaveforstaff.leavestartdate.try(:strftime, '%d-%m-%Y')}<br>#{leaveforstaff.leavenddate.try(:strftime, '%d-%m-%Y')}"
	    duration="#{leaveforstaff.leave_for} #{I18n.t('staff_leave.days')}"
	    
	    if leaveforstaff.approval1?
	      approval1="#{leaveforstaff.approval1_id.blank? ? I18n.t('not_required') : I18n.t('staff_leave.supported')}"
	    else
	      approval1=""
	    end
	    approval2="#{leaveforstaff.approver2? ? I18n.t('staff_leave.approved') : I18n.t('staff_leave.rejected')}"
	    replacement="#{leaveforstaff.replacement_id.blank? ? '-' : leaveforstaff.replacement.staff_with_rank}"
            others=[leavetype, start_end, duration, approval1, approval2, replacement]
	    
            if groupped_leaves.count == 1
                body << ["#{counter += 1}", "#{@college.code=='kskbjb' ?  leaveforstaff.applicant.try(:mykad_with_staff_name) : leaveforstaff.applicant.staff_with_rank}"]+others
            else
                body << ["#{counter += 1}"]+others
            end
        end
    end
    header+[header_title]+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end

end