class Event_listPdf < Prawn::Document
  def initialize(events, view, college)
    super({top_margin: 40, left_margin: 40, page_size: 'A4', page_layout: :portrait })
    @events = events
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
    table(line_item_rows, :column_widths => [30, 100, 60, 60, 80, 80, 110], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
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
    header=[[{content: "#{I18n.t('events.list').upcase}<br> #{@college.name.upcase}", colspan: 7}],
            ["No", I18n.t('events.en'), I18n.t('events.sd'), I18n.t('events.ed'), I18n.t('events.loca'), I18n.t('events.ob'), I18n.t('events.cb')]]
    header +
    @events.map do |event|
        ["#{counter+=1}", event.eventname, "#{event.start_str rescue event.start_at.try(:strftime, "%d-%m-%Y, %a, %l:%M %P")}", "#{event.end_str rescue event.end_at.try(:strftime, "%d-%m-%Y, %a, %l:%M %P")}", event.location, event.officiated, event.staff.try(:name)]
    end
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end

end