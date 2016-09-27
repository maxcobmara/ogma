class BookingfacilityPdf < Prawn::Document  
  def initialize(bookingfacility, view, college)
    super({top_margin: 40, page_size: 'A4', page_layout: :portrait })
    @bookingfacility  = bookingfacility
    @view = view
    font "Helvetica"
    if college.code=="kskbjb"
      move_down 10
    end
    bounding_box([10,770], :width => 400, :height => 100) do |y2|
       image "#{Rails.root}/app/assets/images/logo_kerajaan.png",  :width =>97.2, :height =>77.76
    end
    bounding_box([115,750], :width => 300, :height => 100) do |y2|
      text "#{college.name}", :align => :center, :size => 12,  :style => :bold
      move_down 5
      text "#{I18n.t('campus.bookingfacilities.form_title').upcase}", :align => :center, :style => :bold, :size => 11
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
    move_down 5
    table_main
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  def table_main
    #:padding=>[2,5,3,5] #tlbr
    data=[[{content: "#{ I18n.t('campus.bookingfacilities.applicant_details').upcase}", colspan: 6}],
          ["#{ I18n.t('campus.bookingfacilities.applicant')}", ":",{content:  @bookingfacility.booking_staff.staff_with_rank, colspan: 4}], 
          [I18n.t('campus.bookingfacilities.icno'), ":", @view.formatted_mykad(@bookingfacility.booking_staff.icno), I18n.t('campus.bookingfacilities.phoneno'),":", @bookingfacility.booking_staff.try(:cooftelno)],
          [I18n.t('campus.bookingfacilities.position'), ":", {content: @bookingfacility.booking_staff.position_for_staff, colspan: 4}],
          ["Unit",":",{content: @bookingfacility.booking_staff.positions.try(:first).try(:unit), colspan: 4}],
          [{content: I18n.t('campus.bookingfacilities.booked_facility_details').upcase, colspan: 6}],
          [ I18n.t('campus.bookingfacilities.location_id'), ":", {content: @bookingfacility.booked_facility.location_list, colspan: 4}],
          [ I18n.t('campus.bookingfacilities.usage_date'), ":", @bookingfacility.start_date.strftime("%d-%m-%Y"),  I18n.t('campus.bookingfacilities.until'), ":", @bookingfacility.end_date.strftime("%d-%m-%Y")],
          [ I18n.t('campus.bookingfacilities.usage_time'), ":", @bookingfacility.start_date.strftime("%H:%M %P"),  I18n.t('campus.bookingfacilities.usage_time'), ":", @bookingfacility.end_date.strftime("%H:%M %P")],
          [ I18n.t('campus.bookingfacilities.total_participant'), ":", @bookingfacility.total_participant, "", "", ""],
          [ I18n.t('campus.bookingfacilities.purpose'), ":", {content: @bookingfacility.purpose, colspan: 4}],
          [{content: I18n.t('campus.bookingfacilities.applicant_assurance').upcase, colspan: 6}],
          [ {content: I18n.t('campus.bookingfacilities.assurance_text'), colspan: 6}],
          ["","","","","", "#{I18n.t('campus.bookingfacilities.date')} : #{@bookingfacility.request_date.strftime('%d-%m-%Y')}"],
          [ "(#{I18n.t('campus.bookingfacilities.applicant_signatory')})", {content: "", colspan: 5}],
          [{content:  I18n.t('campus.bookingfacilities.official_use').upcase, colspan: 6}],
          [ {content: "#{I18n.t('campus.bookingfacilities.your_application')} <b>#{@bookingfacility.approval==true ?  I18n.t('approved') :  I18n.t('not_approved')}</b>", colspan: 6}],
           ["","","","","", "#{I18n.t('campus.bookingfacilities.date')} : #{@bookingfacility.approval_date.try(:strftime, '%d-%m-%Y')}"],
           [ "(#{I18n.t('campus.bookingfacilities.approver_signatory')})", {content: "", colspan: 5}],
          [{content: "#{I18n.t('campus.bookingfacilities.name')} : #{@bookingfacility.approving_staff.staff_with_rank}", colspan: 6}],
          [{content: "#{I18n.t('campus.bookingfacilities.position')} : #{ @bookingfacility.approving_staff.positions.try(:first).try(:name)}", colspan: 6}],
          ["", "", "", "", "", ""], [{content: "<i>#{I18n.t('campus.bookingfacilities.computer_generated')}</i>", colspan: 6}]]
    
    table(data, :column_widths => [135,15,140,70,10,140], :cell_style => {:size=>11, :borders => [:left, :right, :top, :bottom],  :inline_format => :true, :padding=>[5,5,5,2]}) do
        row(0).style :align => :center
        row(5).style :align => :center
        row(11).style :align => :center
        row(15).style :align => :center
        row(0).font_style=:bold
        row(5).font_style=:bold
        row(11).font_style=:bold
        row(15).font_style=:bold
        row(12).height=70
        row(16).height=50
	row(14).height=40
	row(1..4).column(0).borders=[:left]
	row(1..4).column(1..4).borders=[]
	row(1).column(2).borders=[:right]
	row(2).column(5).borders=[:right]
	row(3..4).column(2).borders=[:right]
	row(6..10).column(0).borders=[:left]
	row(6).column(1).borders=[]
	row(6).column(2).borders=[:right]
	row(7..10).column(1..4).borders=[]
	row(7..9).column(5).borders=[:right]
	row(10).column(2).borders=[:right]
	row(12).column(0).borders=[:left, :right]
	row(13).column(0).borders=[:left, :bottom]
	row(13).column(1..4).borders=[]
	row(13).column(5).borders=[:right]
	row(14).column(0).borders=[:left, :bottom]
	row(14).column(1).borders=[:bottom, :right]
	row(16).column(0).borders=[:left, :right]
	row(17).column(0).borders=[:left, :bottom]
	row(17).column(1..4).borders=[]
	row(17).column(5).borders=[:right]
	row(18).column(0).borders=[:left]
	row(18).column(1).borders=[:right]
	row(19..20).column(0).borders=[:left, :right]
	row(21).column(0).borders=[:left, :bottom]
	row(21).column(5).borders=[:right, :bottom]
	row(21).column(1..4).borders=[:bottom]
	row(22).column(0).borders=[]
	row(22).style :align => :center
    end
    
  end
  
  def footer
    draw_text "#{page_number} #{I18n.t('instructor_appraisal.from')} 1",  :size => 8, :at => [240,-5]
  end
  
end
