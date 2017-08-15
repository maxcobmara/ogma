class Defect_listPdf < Prawn::Document
  def initialize(defective, view, college)
    super({top_margin: 40, left_margin: 40, page_size: 'A4', page_layout: :portrait })
    @defective = defective
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
    table(line_item_rows, :column_widths => [30, 130, 130, 90, 80, 60], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
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
    header=[[{content: "#{I18n.t('asset.defect.list').upcase}<br> #{@college.name.upcase}", colspan: 6}],
            ["No", "#{I18n.t('asset.assetcode')}", "#{I18n.t('asset.category.type_name_model')}", "#{I18n.t('asset.serial_no')}", "#{I18n.t('location.title')}", "#{ I18n.t('asset.defect.notes')}"]]
    header +
    @defective.map do |defect|
        ["#{counter+=1}", "#{defect.asset.try(:assetcode)}", "#{defect.asset.try(:typename)} - #{defect.asset.name} - #{defect.asset.modelname}", "#{defect.asset.try(:serialno)}", "#{defect.asset.asset_placements.last.try(:location).try(:location_list)}", "" ]
    end
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [720,-5]
  end

end