class Loss_listPdf < Prawn::Document
  def initialize(losses, view, college)
    super({top_margin: 40, left_margin: 40, page_size: 'A4', page_layout: :portrait })
    @losses = losses
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
    table(line_item_rows, :column_widths => [30, 60, 70, 170, 100, 100], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      self.width = 530
    end
  end

  def line_item_rows
    counter = counter||0
    header=[[{content: "#{I18n.t('asset.loss.list').upcase}<br> #{@college.name.upcase}", colspan: 6}],
            ["No", "#{I18n.t('asset.loss.loss_type')}", "#{I18n.t('asset.loss.est_value')}", "#{I18n.t('asset.loss.asset_name')}", "#{I18n.t('asset.loss.loss_location')}", "#{I18n.t('asset.loss.loss_date_time')}"]]
    body=[]
    @losses.group_by{|x|x.document}.each do |approval_document, asset_losses|
      unless approval_document.blank?
	approval=approval_document.doc_details+" : <a href='http://#{@view.request.host}:3003/asset/asset_losses/kewpa31.pdf?id="+"#{approval_document.id}"+"'><b> KEWPA 31</b></a>"
      else
	approval=I18n.t('not_applicable')
      end
      
      body << [{content: "#{approval}", colspan: 6}]
    
      @losses.each do |asset_loss|
         body << ["#{counter+=1}", asset_loss.loss_type.capitalize, @view.ringgols(asset_loss.est_value), asset_loss.asset.code_typename_name_modelname_serialno, asset_loss.try(:location).try(:name), "#{asset_loss.lost_at.strftime('%d %b %Y - %H:%M') unless asset_loss.lost_at.nil?}"]
      end
    end
    
    header+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end

end