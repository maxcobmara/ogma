class Travelclaim_listPdf < Prawn::Document
  def initialize(travel_claims, current_user, view, college)
    super({top_margin: 40, page_size: 'A4', page_layout: :portrait })
    @travel_claims =travel_claims
    @view = view
    @college=current_user.college
    @current_user=current_user
    font "Helvetica"
    record
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  def record
    table(line_item_rows, :column_widths => [30, 90, 150, 80, 170], :cell_style => { :size => 8,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      self.width=520
    end
  end

  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('staff.travel_claim.title').upcase}<br> #{@college.name.upcase}", colspan: 5}],
              [ 'No',  I18n.t('staff.travel_claim.month_year'), I18n.t('staff.travel_claim.name'), I18n.t('staff.travel_claim.total'), 'Status']]
    body=[]
    @travel_claims.each do |travel_claim|
         if travel_claim.travel_requests.count > 0 && travel_claim.travel_requests.map(&:own_car).uniq.include?(true)
             if travel_claim.staff.vehicles.count > 0 &&  travel_claim.staff.current_salary!=nil
                 total= @view.ringgols(travel_claim.total_claims) 
             else
                 if travel_claim.staff.current_salary.nil?
                     total="*1"
                 else
                     total="*2"
                 end
             end
         else
             if travel_claim.staff.current_salary.nil?
                 total="*1"
             else
                 total=@view.ringgols(travel_claim.total_claims)
             end
         end
         body << ["#{counter+=1}", "#{ travel_claim.staff.current_salary.nil? ? I18n.t('staff.travel_claim.insert_current_salary') : travel_claim.claim_month.try(:strftime,'%B %Y')}", travel_claim.staff.staff_with_rank, total, travel_claim.my_claim_status(@current_user).titleize]
    end
    header+body
  end
             
  def footer
    draw_text "#{I18n.t('training.trainingnote.legend')}", :at => [0, 0], :size => 8
    draw_text "*1 - #{I18n.t('staff.travel_claim.insert_current_salary')}", :at => [40, 0], :size => 8
    draw_text "*2 - #{I18n.t('staff.travel_claim.insert_vehicle')}", :at => [40, -10], :size => 8
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end

end