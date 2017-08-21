class Loan_listPdf < Prawn::Document
  def initialize(loans, view, college)
    super({top_margin: 40, left_margin: 40, page_size: 'A4', page_layout: :portrait })
    @loans = loans
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
    table(line_item_rows, :column_widths => [30, 100, 110, 90, 80, 60, 50], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
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
    header=[[{content: "#{I18n.t('asset.loan.asset_on_loan').upcase}<br> #{@college.name.upcase}", colspan: 7}],
            ["No", "#{I18n.t('asset.loan.other_asset')}", "#{I18n.t('asset.loan.staff_id')}<br> / #{I18n.t('asset.loan.reasons')}", "#{I18n.t('asset.loan.loaned_by')} / #{I18n.t('asset.loan.responsible_unit')}", "#{I18n.t('asset.loan.requested_for')} / #{ I18n.t('asset.loan.returned_date')}", "#{I18n.t('asset.loan.approved_date')}", "Status"]]
    body=[]
    @loans.each do |loan|
      if Asset.vehicle.pluck(:id).include?(loan.asset_id)
        asset="#{loan.asset.code_asset} (vehicle)"
      else
        asset=loan.asset.code_typename_name_modelname_serialno
      end
      if loan.is_approved == true
        approval=loan.approved_date.try(:strftime, '%d %b %Y')
      elsif loan.is_approved==false
        approval=I18n.t('asset.loan.rejected')
      else
        approval=I18n.t('asset.loan.pending')
      end
      if loan.is_approved == true && loan.is_returned != true 
        expected=I18n.t('asset.loan.onloan')
        if loan.expected_on==Date.today
          expected+="<br>(#{I18n.t('asset.loan.due_date')})"
        elsif loan.expected_on < Date.today
          expected+="<br>(#{I18n.t('asset.loan.overdue')}}"
        end
      elsif loan.is_approved == true && loan.is_returned == true
        expected=I18n.t('asset.loan.is_returned')
      end
      
      body << ["#{counter+=1}", asset, "#{loan.staff.staff_with_rank}<br>#{loan.reasons.capitalize}", "#{loan.asset.assignedto.staff_with_rank unless loan.asset.assignedto.blank?}<br>#{loan.asset.assignedto.positions.first.unit unless loan.asset.assignedto.positions.blank?}", "#{loan.loaned_on.try(:strftime, '%d %b %Y')}<br>#{loan.expected_on.try(:strftime, '%d %b %Y')}", approval, expected]
    end
    
    header+body   
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end

end