class Tenant_reportPdf < Prawn::Document 
  def initialize(tenants, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :landscape })
    @tenants = tenants
    @view = view
    @college = college
    font "Times-Roman"
    text "#{college.name}", :align => :center, :size => 12, :style => :bold
    text "#{I18n.t('student.tenant.list_full')}", :align => :center, :size => 12, :style => :bold
    move_down 10
    record
  end
  
  def record
    row_programme=[1]
    row_p=0
    no=0
    @tenants.group_by{|x|x.student.intakestudent}.each do |sintake, tenants|
      if no > 0
        row_programme << tenants.count+1+no
      end
      no+=1
    end
    table(line_item_rows, :column_widths => [25,80,80,135,85,55,55,55,55,50,105], :cell_style => { :size => 8,  :inline_format => :true}) do
      row(0).font_style = :bold
      row(0).background_color = 'FFE34D'
      for arow in row_programme
        row(arow).background_color="FDF8A1"
        row(arow).font_style=:bold
        row(arow).align=:center
      end
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 780
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
    header = [[ "", "#{I18n.t('location.code')}", "#{I18n.t('student.students.icno')}",  "#{I18n.t('student.name')}",  "#{@college.code=='amsas' ? I18n.t('student.students.apmmno') : I18n.t('student.students.matrixno')}",    "#{I18n.t('student.tenant.key.provided')}",  "#{I18n.t('student.tenant.key.expected')}",  "#{I18n.t('student.tenant.key.returned')}",  "#{I18n.t('student.tenant.vacate')}",  "#{I18n.t('student.tenant.damage_status')}",  "#{I18n.t('student.tenant.damage_type')}"]]   
    body=[]
    @tenants.group_by{|x|x.student.intakestudent}.each do |sintake, tenants|
      body << [{content: "#{sintake.siri_programmelist}", colspan: 11}]
      for tenant in tenants
          body <<["#{counter += 1}", "#{tenant.location.try(:combo_code)}", 
                 "#{@view.formatted_mykad(tenant.try(:student).try(:icno)) unless tenant.student.nil?} #{(I18n.t 'student.tenant.tenancy_details_nil') if tenant.student.nil?}", "#{tenant.try(:student).try(:name) unless tenant.student.nil?}", "#{tenant.try(:student).try(:matrixno) unless tenant.student.nil?}", "#{ I18n.l(tenant.keyaccept, :format => '%d %b %Y') rescue nil}", "#{ I18n.l(tenant.keyexpectedreturn, :format => '%d %b %Y') unless tenant.keyexpectedreturn.blank?}", "#{ I18n.l(tenant.keyreturned, :format => '%d %m %Y') unless tenant.keyreturned.blank?}",  "#{ tenant.force_vacate? ? (I18n.t 'yes2') : (I18n.t 'no2')}",  "#{ (I18n.t 'no2') if tenant.damages.count==0} #{(I18n.t 'yes2') if tenant.damages.count!=0 }", "#{@wa[counter-1]}"]
      end
    end
    header+body
  end
  
end
