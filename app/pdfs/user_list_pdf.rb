class User_listPdf < Prawn::Document
  def initialize(users, view, curr_usr)
    super({top_margin: 30, page_size: 'A4', page_layout: :portrait })
    @users = users
    @view = view
    @college=curr_usr.college
    @curr_usr=curr_usr
    font "Helvetica"
    record
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  def record
    columnswidth=[30, 120, 100, 100, 60, 120]
    table(line_item_rows, :column_widths => columnswidth, :cell_style => { :size => 8,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      self.width=530
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{@college.name.upcase}<br>#{I18n.t('staff.list').upcase}", colspan: 6}]]
    header << ["No", I18n.t('user.email'), I18n.t('user.userable_id'), "#{I18n.t('user.position')} / Unit", I18n.t('user.userable_type'), I18n.t('user.roles')]
    body=[]
    
    @users.map do |user|
        uroles=user.roles.join(", ")
        complete_name=user.userable && user.userable_type=='Staff' ? user.userable.try(:staff_with_rank) : user.userable.try(:student_with_rank)
        if user.userable && (user.userable_type == "Staff" || user.userable_type == "Student")
             positions=user.userable_type == "Staff" ? (user.userable.positions_units(@view.is_developer?)).html_safe : I18n.t('not_applicable')
	else 
	   unless user.userable_type.blank?
	     positions=user.userable_type == "Staff" ? I18n.t('user.staff_removed') : I18n.t('user.student_removed')
	     positions+="<br>#{I18n.t('user.userable_removed2')}"
	   end
        end
	if user.userable && (user.userable_type == "Staff" || user.userable_type == "Student")
          a=""
	else
	  unless user.userable_type.blank?
	    a=" (X)" #red & strikethrough (staff/student record no longer exist)
# 	   else
# 	     a="*"  #blue
	  end
	end
        if user.userable_type == "Staff" 
          type_rem=I18n.t('staff.title')+a
	elsif user.userable_type == "Student"
          type_rem=I18n.t('student.title')+a
        else
	  type_rem=I18n.t('user.user_not_link_entity')
        end
        body << ["#{counter += 1}", user.email, complete_name, positions, type_rem, @view.translated_list_comma(user.roles.pluck(:authname)) ]
    end
    
    header+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end

end