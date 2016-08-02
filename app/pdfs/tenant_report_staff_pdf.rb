class Tenant_report_staffPdf < Prawn::Document 
  def initialize(tenants, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :landscape })
    @tenants = tenants
    @view = view
    font "Times-Roman"
    text "#{college.name}", :align => :center, :size => 12, :style => :bold
    text "#{I18n.t('student.tenant.list_full2')}", :align => :center, :size => 12, :style => :bold
    move_down 10
    record
  end
  
  def record
    table(line_item_rows, :column_widths => [25,60,70,135,60,70,70,60,60,130], :cell_style => { :size => 8,  :inline_format => :true}) do
      row(0).font_style = :bold
      row(0).background_color = 'FFE34D'
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 740
      header = true
    end
  end
  
  def line_item_rows
    @wa=[]
    @tenants.each do |tenant|
      damage_description=[]
      if tenant.damages.count>0
        tenant.damages.each{|t|damage_description << t.damage_type}
      end
      @wa << damage_description.uniq.to_sentence
    end
    
    counter = counter || 0
    header = [[ "", "#{I18n.t('location.code')}", "#{I18n.t('student.students.icno')}",  "#{I18n.t('student.name')}",  "#{I18n.t('student.tenant.key.provided')}",  "#{I18n.t('student.tenant.key.expected')}",  "#{I18n.t('student.tenant.key.returned')}",  "#{I18n.t('student.tenant.vacate')}",  "#{I18n.t('student.tenant.damage_status')}",  "#{I18n.t('student.tenant.damage_type')}"]]   
    header +
      @tenants.map do |tenant|
      ["#{counter += 1}", "#{tenant.location.try(:combo_code)}", 
       "#{tenant.try(:staff).try(:icno) unless tenant.staff.nil?} #{(I18n.t 'student.tenant.tenancy_details_nil') if tenant.staff.nil?}", 
       "#{tenant.try(:staff).try(:name) unless tenant.staff.nil?}", 
       "#{ I18n.l(tenant.keyaccept, :format => '%d %b %y') rescue nil}",
       "#{ I18n.l(tenant.keyexpectedreturn, :format => '%d %b %y') unless tenant.keyexpectedreturn.blank?}", 
       "#{ I18n.l(tenant.keyreturned, :format => '%d %b %y') unless tenant.keyreturned.blank?}", 
       "#{ tenant.force_vacate? ? (I18n.t 'yes2') : (I18n.t 'no2')}", 
       "#{ (I18n.t 'no2') if tenant.damages.count==0} #{(I18n.t 'yes2') if tenant.damages.count!=0 }", 
       "#{@wa[counter-1]}"]
    end
  end
  
end
