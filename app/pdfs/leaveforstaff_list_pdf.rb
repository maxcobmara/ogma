class Leaveforstaff_listPdf < Prawn::Document
  def initialize(leaveforstaffs, view, curr_user, is_admin)
    super({top_margin: 50, left_margin: 40, page_size: 'A4', page_layout: :portrait })
    @leaveforstaffs = leaveforstaffs
    @view = view
    @college=curr_user.college
    @is_admin=is_admin
    ###
    @astaff=curr_user.userable
    u=curr_user.userable_id
    @owns = @leaveforstaffs.where(staff_id: u)
    @for_supports = @leaveforstaffs.where(approval1_id: u)                                            #.where(approval1: nil)
    @for_approvals = @leaveforstaffs.where(approval2_id: u)                                           #.where(approval1: true).where(approver2: nil)
    if @is_admin
      @others=@leaveforstaffs.where('staff_id !=? and approval1_id!=? and approval2_id!=?', u, u, u)
    end
    ###
    font "Helvetica"
    record
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  def record
    columnswidth=[30, 60, 60, 50, 120, 120, 90]
    row_counts=[]
    row_subtitles=[]
    row_separators=[]
    rowno=2
    recs_per_applicant=0
    
    #supporting
    row_subtitles << rowno
    rowno+=1
    gsupports=@for_supports.group_by(&:applicant).sort_by{|a, b|a.name}
    gsupports.each do |applicant, leaveforstaffs|
      row_counts << rowno+recs_per_applicant
      recs_per_applicant+=leaveforstaffs.count+1
    end
    row_separators << rowno+gsupports.count+@for_supports.count
    rowno+=1
    
    #approving
    row_subtitles << rowno+gsupports.count+@for_supports.count
    rowno+=1
    gapprovals=@for_approvals.group_by(&:applicant).sort_by{|a, b|a.name}
    gapprovals.each do |applicant, leaveforstaffs|
      row_counts << rowno+recs_per_applicant
      recs_per_applicant+=leaveforstaffs.count+1
    end
    row_separators << rowno+(gsupports.count+@for_supports.count)+(gapprovals.count+@for_approvals.count)
    rowno+=1
    
    #own
    row_subtitles << rowno+(gsupports.count+@for_supports.count)+(gapprovals.count+@for_approvals.count)
    rowno+=1
    gowns=@owns.group_by(&:applicant).sort_by{|a, b|a.name}
    recs_per_applicant+=@owns.count
    row_separators << rowno+(gsupports.count+@for_supports.count)+(gapprovals.count+@for_approvals.count)+(@owns.count)
    rowno+=1
    
    #others (not related)
    row_subtitles <<  rowno+(gsupports.count+@for_supports.count)+(gapprovals.count+@for_approvals.count)+(@owns.count)
    rowno+=1
    gothers=@others.group_by(&:applicant).sort_by{|a, b|a.name}
    gothers.each do |applicant, leaveforstaffs|
      row_counts << rowno+recs_per_applicant
      recs_per_applicant+=leaveforstaffs.count+1
    end
    row_separators << rowno+(gsupports.count+@for_supports.count)+(gapprovals.count+@for_approvals.count)+(@owns.count)+ (gothers.count+@others.count)
    
    table(line_item_rows, :column_widths => columnswidth, :cell_style => { :size => 8,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      if row_subtitles.count > 0
	for row_subtitle in row_subtitles
	  row(row_subtitle).font_style=:bold
	  row(row_subtitle).align =:center
	  row(row_subtitle).background_color='f8dd78'
	end
      end
      if row_counts.count > 0
        for row_count in row_counts
          row(row_count).font_style=:bold
	  row(row_count).align =:center
	  row(row_count).background_color='FDF8A1'
        end
      end
      for row_separator in row_separators
	row(row_separator).height=10
      end
      self.width=530
    end
  end
  
  def line_item_rows
    header = [[{content: "#{I18n.t('staff_leave.list').upcase}<br> #{@college.name.upcase}", colspan: 7}]]
    header_title=["No", I18n.t('staff_leave.leavetype'), "#{I18n.t('staff_leave.from')} / #{I18n.t('staff_leave.to')}", I18n.t('staff_leave.duration'), "#{I18n.t('staff_leave.supported')} ?", "#{I18n.t('staff_leave.approved')} ?", I18n.t('staff_leave.replacement')]
    a=[]
    
    #supporting ---
    a+=[[{content: "#{I18n.t('staff_leave.supports_subtitle')} :  (#{@for_supports.size})", colspan: 7}]]  
    if @for_supports.size > 0
      a+=groupped_leaves_lines(@for_supports)
    end
    a+=[[{content: "", colspan: 7}]]
    #approving ---
    a+=[[{content: "#{I18n.t('staff_leave.approvals_subtitle')} :  (#{@for_approvals.size})", colspan: 7}]]
    if @for_approvals.size > 0
      a+=groupped_leaves_lines(@for_approvals)
    end
    a+=[[{content: "", colspan: 7}]]
    #own ---
    a+=[[{content: "#{I18n.t('staff_leave.owns_subtitle')} :  (#{@college.code=='amsas' ? @astaff.try(:staff_with_rank) : @astaff.try(:mykad_with_staff_name)})", colspan: 7}]]
     if @owns.size > 0
      a+=groupped_leaves_lines(@owns)
    end
    a+=[[{content: "", colspan: 7}]]
    #others (not related) ---
    a+=[[{content: "#{I18n.t('staff_leave.others_subtitle')} (#{@others.size})", colspan: 7}]]
    if @others.size > 0
      a+=groupped_leaves_lines(@others)
    end
    a+=[[{content: "", colspan: 7}]]
    
    header+[header_title]+a
  end
  
  def groupped_leaves_lines(ll)
    body=[]
    counter = counter || 0
    groupped_leaves=ll.group_by(&:applicant).sort_by{|a, b|a.name}
    groupped_leaves.each do |applicant, leaveforstaffs|
        if applicant != @astaff
          body << [{content: "#{I18n.t('staff_leave.staff_id')} : #{@college.code=='kskbjb' ? applicant.try(:mykad_with_staff_name) : applicant.try(:staff_with_rank)}", colspan: 7}]
	end
        for leaveforstaff in leaveforstaffs
            leavetype=(DropDown::STAFFLEAVETYPE.find_all{|disp, value| value == leaveforstaff.leavetype}).map {|disp, value| disp} [0]
	    start_end="#{leaveforstaff.leavestartdate.try(:strftime, '%d-%m-%Y')}<br>#{leaveforstaff.leavenddate.try(:strftime, '%d-%m-%Y')}"
	    duration="#{leaveforstaff.leave_for} #{I18n.t('staff_leave.days')}"
	    
	    if leaveforstaff.approval1_id.blank?
              approval1=I18n.t('not_required')
            else 
              if leaveforstaff.approval1==true
                approval1= I18n.t('staff_leave.supported')
              elsif leaveforstaff.approval1==false
                approval1=I18n.t('staff_leave.rejected')
              else
                approval1=I18n.t('staff_leave.awaiting_support')
		app= leaveforstaff.approval1_id.blank? ? "" : "#{leaveforstaff.try(:seconder).try(:staff_with_rank_position)}"
		approval1+=app
              end
	    end
	    
	    if leaveforstaff.approval2_id.blank? 
	      approval2=I18n.t('not_required')
	    else
	      if leaveforstaff.approver2==true
	        approval2=I18n.t('staff_leave.approved')
	      elsif leaveforstaff.approver2==false  
		approval2=I18n.t('staff_leave.rejected')
	      else
		if leaveforstaff.approval1==true
		  approval2=I18n.t('staff_leave.awaiting_approval')
		  app2=leaveforstaff.approval2_id.blank? ? "" : "#{leaveforstaff.try(:approver).try(:staff_with_rank_position)}"
		  approval2+=app2
		end
	      end
	    end
	    
	    replacement="#{leaveforstaff.replacement_id.blank? ? '-' : leaveforstaff.replacement.staff_with_rank}"
            others=[leavetype, start_end, duration, approval1, approval2, replacement]
	    
	    body << ["#{counter += 1}"]+others
        end
	
      end
      body
  end

  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end
  
#   def record
#     groupped_leaves=@leaveforstaffs.group_by(&:applicant).sort_by{|a, b|a.name}
#     if groupped_leaves.count > 1
#       columnswidth=[30, 100, 60, 60, 80, 80, 130]
#       row_counts=[]
#       rowno=2
#       recs_per_applicant=0
#       groupped_leaves.each do |applicant, leaveforstaffs|
#           row_counts << rowno+recs_per_applicant
#           recs_per_applicant+=leaveforstaffs.count+1
#       end
#     else
#       columnswidth=[30, 90, 50, 55, 40, 88, 87, 100]
#     end
#     
#     table(line_item_rows, :column_widths => columnswidth, :cell_style => { :size => 8,  :inline_format => :true}, :header => 2) do
#       row(0).borders =[]
#       row(0).height=50
#       row(0).style size: 11
#       row(0).align = :center
#       row(0..1).font_style = :bold
#       row(1).background_color = 'FFE34D'
#       if groupped_leaves.count > 1
#         for row_count in row_counts
#           row(row_count).font_style=:bold
# 	  row(row_count).align =:center
# 	  row(row_count).background_color='FDF8A1'
#         end
#       end
#       self.width=540
#     end
#   end
    
#   def line_item_rows
#     groupped_leaves=@leaveforstaffs.group_by(&:applicant).sort_by{|a, b|a.name}
#     if groupped_leaves.count > 1
#       colcount=7
#     else
#       colcount=8
#     end
#     counter = counter || 0
#     header = [[{content: "#{I18n.t('staff_leave.list').upcase}<br> #{@college.name.upcase}", colspan: colcount}]]
#     if groupped_leaves.count == 1
#       header_title=["No", "#{@college.code=='kskbjb' ? I18n.t('staff_leave.id') : I18n.t('staff_leave.staff_id')}"]
#     else
#       header_title=["No"]
#     end
#     header_title +=[I18n.t('staff_leave.leavetype'), "#{I18n.t('staff_leave.from')} / #{I18n.t('staff_leave.to')}", I18n.t('staff_leave.duration'), "#{I18n.t('staff_leave.supported')} ?", "#{I18n.t('staff_leave.approved')} ?", I18n.t('staff_leave.replacement')]
#     body=[]
#     groupped_leaves.each do |applicant, leaveforstaffs|
#         if groupped_leaves.count > 1
#           body << [{content: "#{I18n.t('staff_leave.staff_id')} : #{@college.code=='kskbjb' ? applicant.try(:mykad_with_staff_name) : applicant.try(:staff_with_rank)}", colspan: 7}]
#         end
#         for leaveforstaff in leaveforstaffs
# 	    leavetype=(DropDown::STAFFLEAVETYPE.find_all{|disp, value| value == leaveforstaff.leavetype}).map {|disp, value| disp} [0]
# 	    start_end="#{leaveforstaff.leavestartdate.try(:strftime, '%d-%m-%Y')}<br>#{leaveforstaff.leavenddate.try(:strftime, '%d-%m-%Y')}"
# 	    duration="#{leaveforstaff.leave_for} #{I18n.t('staff_leave.days')}"
# 
# # 	    if leaveforstaff.approval1?
# # 	      approval1="#{leaveforstaff.approval1_id.blank? ? I18n.t('not_required') : I18n.t('staff_leave.supported')}"
# # 	    else
# # 	      approval1=""
# # 	    end
#             if leaveforstaff.approval1_id.blank?
#               approval1=I18n.t('not_required')
#             else 
#               if leaveforstaff.approval1==true
#                 approval1= I18n.t('staff_leave.supported')
#               elsif leaveforstaff.approval1==false
#                 approval1=I18n.t('staff_leave.rejected')
#               else
#                 approval1=I18n.t('staff_leave.awaiting_support')
# 		app= leaveforstaff.approval1_id.blank? ? "" : "#{leaveforstaff.try(:seconder).try(:staff_with_rank_position)}"
# 		approval1+=app
#               end
# 	    end
# 
# 	    #approval2="#{leaveforstaff.approver2? ? I18n.t('staff_leave.approved') : I18n.t('staff_leave.rejected')}"
#             if leaveforstaff.approval2_id.blank? 
# 	      approval2=I18n.t('not_required')
# 	    else
# 	      if leaveforstaff.approver2==true
# 	        approval2=I18n.t('staff_leave.approved')
# 	      elsif leaveforstaff.approver2==false  
# 		approval2=I18n.t('staff_leave.rejected')
# 	      else
# 		if leaveforstaff.approval1==true
# 		  approval2=I18n.t('staff_leave.awaiting_approval')
# 		  app2=leaveforstaff.approval2_id.blank? ? "" : "#{leaveforstaff.try(:approver).try(:staff_with_rank_position)}"
# 		  approval2+=app2
# 		end
# 	      end
# 	    end
# 	    
# 	    replacement="#{leaveforstaff.replacement_id.blank? ? '-' : leaveforstaff.replacement.staff_with_rank}"
#             others=[leavetype, start_end, duration, approval1, approval2, replacement]
# 	    
#             if groupped_leaves.count == 1
#                 body << ["#{counter += 1}", "#{@college.code=='kskbjb' ?  leaveforstaff.applicant.try(:mykad_with_staff_name) : leaveforstaff.applicant.staff_with_rank}"]+others
#             else
#                 body << ["#{counter += 1}"]+others
#             end
#         end
#     end
#     header+[header_title]+body
#   end

end