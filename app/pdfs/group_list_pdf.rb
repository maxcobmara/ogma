class Group_listPdf < Prawn::Document
  def initialize(groups, view, curr_usr)
    super({top_margin: 40, left_margin: 40, page_size: 'A4', page_layout: :portrait })
    @groups = groups
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
    table(line_item_rows, :column_widths => [30, 70, 100, 100, 220], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      self.width = 520
    end
  end

  def line_item_rows
    counter = counter||0
    header=[[{content: "#{I18n.t('group.list').upcase}<br> #{@college.name.upcase}", colspan: 5}],
            ["No", I18n.t('group.membership'), I18n.t('group.name'), I18n.t('group.description'), "#{I18n.t('group.members')} (#{I18n.t('group.position')})"]]
    body =[]
    @groups.each do |group|
        if group.members[:user_ids].nil?
          recipient_list=[]
        else
          recipient_list=(group.members[:user_ids]-[""]).collect{|x|x.to_i}
        end
        staffs=Staff.joins(:users).where('users.id IN(?)', recipient_list).map(&:staff_with_rank_position)
	staff_list=""
        staffs.each_with_index{|x, y|staff_list+="#{(y+1)}. #{x}<br>"}
        body << ["#{counter+=1}", "#{group.is_member(@curr_usr.id) ? I18n.t('yes2') : I18n.t('no2')}", group.name, group.description, staff_list ]
    end
    header+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end

end