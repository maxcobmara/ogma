class Damage_report_staffPdf < Prawn::Document 
  def initialize(damages, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @damages = damages
    @view = view
    font "Times-Roman"
    text "Kolej Sains Kesihatan Bersekutu Johor Bahru", :align => :center, :size => 12, :style => :bold
    text "#{I18n.t('location.damage.damage_report_staff')}", :align => :center, :size => 12, :style => :bold
    move_down 10
    record
  end
  
  def record
    table(line_item_rows, :column_widths => [30,70, 80, 170, 60, 60, 70], :cell_style => { :size => 10,  :inline_format => :true}) do
      row(0).font_style = :bold
      row(0).background_color = 'FFE34D'
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 540
      header = true
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[ "", "#{I18n.t('location.combo_code')}","#{I18n.t('student.tenant.damage_type')}", "#{I18n.t('location.damage.description')}", "#{I18n.t('location.damage.reported_on')}", "#{I18n.t('location.damage.repaired_on')}", "#{I18n.t('student.tenant.name')}"]]   
    header +
      @damages.map do |damage|
      ["#{counter += 1}", "#{damage.try(:location).try(:combo_code)}", "#{damage.damage_type} " , "#{damage.description_assetcode}"," #{damage.reported_on.try(:strftime, '%d-%m-%Y')}", "#{damage.repaired_on.try(:strftime, '%d-%m-%Y')}",  "#{damage.try(:tenant).try(:student).try(:name)}"]
    end
  end
  
end

