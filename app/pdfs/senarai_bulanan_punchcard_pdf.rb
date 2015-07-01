class Senarai_bulanan_punchcardPdf < Prawn::Document
  def initialize(staff_attendances, monthly_list, unit_department, thumb_id, view)
    super({top_margin: 20, left_margin: 70, page_size: 'A4', page_layout: :portrait })
    @staff_attendances = staff_attendances
    @monthly_list=monthly_list
    @unit_department=unit_department
    @thumb_id=thumb_id
    @view = view
    font "Times-Roman"
    repeat :all do
      text "#{@monthly_list.beginning_of_month.strftime('%d-%m-%Y')} to #{@monthly_list.end_of_month.strftime('%d-%m-%Y')}", :align => :right, :size => 9
    end
    move_down 10
    text "Monthly Attendance Listing", :align => :center, :size => 12, :style => :bold
    move_down 10
    text "Department / Unit : #{@unit_department}", :size => 11
    thumb_dup=Staff.where(thumb_id: @thumb_id)
    if thumb_dup.count > 1 
      if @thumb_id.blank?
	move_down 50
        text "Thumb ID must exist for each staff."
      else
        staff_names=thumb_dup.pluck(:name)
        staff_names=staff_names.join(", ") if thumb_dup.count > 1
        move_down 50
        text "Thumb ID must unique for each staff. There are #{thumb_dup.count} staffs using the same Thumb ID : #{@thumb_id}", :size => 11
        move_down 5
        text "#{staff_names}", :size => 11
      end
    else
      text "#{Staff.where(thumb_id: @thumb_id).first.name.upcase}", :size => 11
      move_down 5
      if @staff_attendances.count > 0
        attendance_list
        move_down 10
        text "C/In :   #{@staff_attendances.where('log_type ILIKE?', '%I%').count}", :size => 11
        text "C/Out :   #{@staff_attendances.where('log_type ILIKE?', '%O%').count}", :size => 11
      else
        move_down 20
        text "Data not exist", :size => 12
      end
      repeat(lambda {|pg| pg > 1}) do
        draw_text "#{Staff.where(thumb_id: @thumb_id).first.name}", :at => bounds.bottom_left, :size =>9
      end
    end 
  end

  def attendance_list
    total_rows=@staff_attendances.count-1
    table(line_item_rows, :column_widths => [70, 70, 70], :cell_style => { :size => 10,  :inline_format => :true}) do
      #leave empty for full borders
    end
  end
  
  def line_item_rows     
    counter = counter || 0    
    attendance_list = 
      @staff_attendances.map do |sa|
      ["#{sa.logged_at.strftime('%m-%d')}", "#{sa.logged_at.strftime('%H:%M')}", "#{'C/In' if sa.log_type=='I' || sa.log_type=='i' } #{'C/Out' if sa.log_type=='O' || sa.log_type=='o' }" ]
    end
  end

end