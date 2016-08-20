class Laporan_penginapanPdf < Prawn::Document 
  def initialize(residential, current_tenants, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @residential = residential
    @current_tenants = current_tenants
    @view = view
    font "Times-Roman"
    text "#{college.name}", :align => :center, :size => 12, :style => :bold
    text "#{I18n.t('student.tenant.report_main')}", :align => :center, :size => 12, :style => :bold
    move_down 10
    text "#{@residential.name}"
    move_down 5
    record
  end
  
  def record
    table(line_item_rows, :column_widths => [100,100,100,100,100], :cell_style => { :size => 10,  :inline_format => :true}) do
      row(0).font_style = :bold
      row(0).background_color = 'FFE34D'
      columns(1..3).align=:center
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 500
      header = true
    end
  end
  
  def line_item_rows
    @all=[]
    @occupied_beds=[]
    @occupied=[]
    @damaged=[]
    @empty=[]
    
    @residential.children.sort.reverse.each do |floor|
      @all << floor.descendants.where(typename: [2,8]).pluck(:combo_code).group_by{|x|x[0, x.size-2]} 
      @occupied_beds = floor.descendants.where(typename: [2,8]).joins(:tenants).where("tenants.id" => @current_tenants)
      @occupied << @occupied_beds.pluck(:combo_code).group_by{|x|x[0, x.size-2]} 
      @damaged << floor.descendants.where(occupied: true).where(typename: 6) #NOTE:is a room
    end
    
    counter = counter || 0
    header = [[ "#{I18n.t('student.tenant.level')}", "#{I18n.t('student.tenant.occupied')}", "#{I18n.t('student.tenant.empty')}", "#{I18n.t( 'student.tenant.damaged')}",  "#{I18n.t( 'student.tenant.notes')}"]]   
    lineitemsrows=[]
    @residential.children.sort.reverse.map do |floor|
      lineitemsrows << ["#{floor.name}", "#{ (@occupied[counter]).count}", "#{(@all[counter]).count-(@occupied[counter]).count-(@damaged[counter]).count}", "#{(@damaged[counter]).count}", ""]
      counter+=1
    end
    header +lineitemsrows
  end
  
end
