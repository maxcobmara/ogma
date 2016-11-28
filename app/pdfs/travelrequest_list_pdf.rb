class Travelrequest_listPdf < Prawn::Document
  def initialize(for_approvals, travel_requests, view, college)
    super({top_margin: 40, page_size: 'A4', page_layout: :portrait })
    @for_approvals=for_approvals
    @travel_requests =travel_requests
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
    title1=2
    row_counts=[title1]
    row_counts << title1+@for_approvals.count+2
    table(line_item_rows, :column_widths => [30, 65, 80, 80, 50, 50, 70, 55, 60], :cell_style => { :size => 8,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      for row_count in row_counts
          row(row_count).background_color ='FDF8A1'
          row(row_count).font_style=:bold
      end
      self.width=540
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('staff.travel_request.title').upcase}<br> #{@college.name.upcase}", colspan: 9}],
              [ 'No',  I18n.t('staff.travel_request.document_id'),  I18n.t('staff.travel_request.staff_id'),  I18n.t('staff.travel_request.destination'),  I18n.t('staff.travel_request.depart_at'),  I18n.t('staff.travel_request.return_at'),  I18n.t('staff.travel_request.purpose'),  I18n.t('staff.travel_request.is_submitted'),  I18n.t('staff.travel_request.hod_accept')]]
    title1=[[{content: I18n.t('staff.travel_request.for_approval'), colspan: 9}]]
    body=[]
    @for_approvals.each do |for_approval|
        body << ["#{counter += 1}", for_approval.try(:document).try(:refno),  @college.code=='amsas' ? for_approval.applicant.staff_with_rank : for_approval.applicant.try(:staff_name_with_position), for_approval.destination, "#{@college.code=='amsas' ? for_approval.depart_at.try(:strftime, '%d-%m-%Y %H:%M') : for_approval.depart_at.try(:strftime, '%d %b %Y %l:%M %P')}", "#{@college.code=='amsas' ? for_approval.return_at.try(:strftime, '%d-%m-%Y %H:%M') : for_approval.return_at.try(:strftime, '%d %b %Y %l:%M %P')}", for_approval.document.try(:title), "#{for_approval.is_submitted? ? I18n.t('submitted') : I18n.t('not_submitted')}", "#{for_approval.hod_accept? ? I18n.t('approved') : I18n.t('not_approved')}" ]
    end
    counter2 = counter2 || 0
    title2=[[{content: I18n.t('staff.travel_request.my_travel_request'), colspan: 9}]]
    body2=[]
    @travel_requests.each do |travel_request|
      body2 << ["#{counter2+=1}", travel_request.try(:document).try(:refno), @college.code=='amsas' ? travel_request.applicant.staff_with_rank : travel_request.applicant.try(:staff_name_with_position), travel_request.destination, "#{@college.code=='amsas' ? travel_request.depart_at.try(:strftime, '%d-%m-%Y %H:%M') : travel_request.depart_at.try(:strftime, '%d %b %Y %l:%M %P')}", "#{@college.code=='amsas' ? travel_request.return_at.try(:strftime, '%d-%m-%Y %l:%M') : travel_request.return_at.try(:strftime, '%d %b %Y %l:%M %P')}", travel_request.document.try(:title), "#{travel_request.is_submitted? ? I18n.t('submitted') : I18n.t('not_submitted')}", "#{travel_request.hod_accept? ? I18n.t('approved') : I18n.t('not_approved')}"]
    end
    header+title1+body+[[{content: "", colspan: 9}]]+title2+body2+[[{content: "", colspan: 9}]]
  end

  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end

end