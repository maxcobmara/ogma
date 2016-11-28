class Travellog_listPdf < Prawn::Document
  def initialize(my_approved_requests, view, college)
    super({top_margin: 40, page_size: 'A4', page_layout: :portrait })
    @my_approved_requests=my_approved_requests
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
    table(line_item_rows, :column_widths => [30, 65, 90, 80, 50, 50, 90, 85], :cell_style => { :size => 8,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      self.width=540
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('staff.travel_request.my_travel_logs').upcase}<br> #{@college.name.upcase}", colspan: 8}],
              [ 'No',  I18n.t('staff.travel_request.document_id'),  I18n.t('staff.travel_request.staff_id'),  I18n.t('staff.travel_request.destination'),  I18n.t('staff.travel_request.depart_at'),  I18n.t('staff.travel_request.return_at'),  I18n.t('staff.travel_request.purpose'), I18n.t('staff.travel_request.hod_accept')]]
    body=[]
    @my_approved_requests.each do |request|
        body << ["#{counter += 1}", request.try(:document).try(:refno),  @college.code=='amsas' ? request.applicant.staff_with_rank : request.applicant.try(:staff_name_with_position), request.destination, "#{@college.code=='amsas' ? request.depart_at.try(:strftime, '%d-%m-%Y %H:%M') : request.depart_at.try(:strftime, '%d %b %Y %l:%M %P')}", "#{@college.code=='amsas' ? request.return_at.try(:strftime, '%d-%m-%Y %H:%M') : request.return_at.try(:strftime, '%d %b %Y %l:%M %P')}", request.document.try(:title), "#{request.hod_accept? ? I18n.t('approved') : I18n.t('not_approved')}" ]
    end
    header+body
  end

  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end

end