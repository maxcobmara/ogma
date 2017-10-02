class Damage_reportPdf < Prawn::Document 
  def initialize(damages, view, college)
    super({top_margin: 50, left_margin: 40, page_size: 'A4', page_layout: :portrait })
    @damages = damages
    @view = view
    font "Helvetica" #"Times-Roman"
    text "#{college.name}", :align => :center, :size => 12, :style => :bold
    text "#{I18n.t('location.damage.damage_report')}", :align => :center, :size => 12, :style => :bold
    move_down 10
    record
  end
  
  def record
    table(line_item_rows, :column_widths => [30,85, 75, 130, 60, 60, 90], :cell_style => { :size => 9,  :inline_format => :true}) do
      row(0).font_style = :bold
      row(0).background_color = 'FFE34D'
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 530
      header = true
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[ "", "#{I18n.t('location.title')}","#{I18n.t('student.tenant.damage_type')}", "#{I18n.t('location.damage.description')}", "#{I18n.t('location.damage.reported_on')}", "#{I18n.t('location.damage.repaired_on')}", "#{I18n.t('student.tenant.name')}"]]   
    header+
     @damages.map do |damage|
         ["#{counter += 1}", damage.try(:location).try(:combo_code), "#{damage.damage_type} " , "#{damage.description_assetcode}"," #{damage.reported_on.try(:strftime, '%d-%m-%Y')}", "#{damage.repaired_on.try(:strftime, '%d-%m-%Y')}",  "#{damage.try(:tenant).try(:student).try(:name)}"]
    end
    
#     body=[]
#     @damages.group_by(&:location).each do |alocation, damages|
#       no=0
#       for damage in damages
#           if no==0
#               body << ["#{counter += 1}", {content: alocation.try(:combo_code), rowspan: damages.count}, "#{damage.damage_type} " , "#{damage.description_assetcode}"," #{damage.reported_on.try(:strftime, '%d-%m-%Y')}", "#{damage.repaired_on.try(:strftime, '%d-%m-%Y')}",  "#{damage.try(:tenant).try(:student).try(:name)}"]
#           else
# 	      body << ["#{counter += 1}", "#{damage.damage_type} " , "#{damage.description_assetcode}"," #{damage.reported_on.try(:strftime, '%d-%m-%Y')}", "#{damage.repaired_on.try(:strftime, '%d-%m-%Y')}",  "#{damage.try(:tenant).try(:student).try(:name)}"]
#           end
#           no+=1
#       end
#     end
#     header+body
  end
  
end
