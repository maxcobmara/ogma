class Organisation_chartPdf < Prawn::Document 
  def initialize(positions, pa, view)
    super({top_margin: 20, left_margin: 20, page_size: 'A4', page_layout: :landscape })
    @positions = positions
    @pa = pa
    @view = view
    font "Helvetica"
    
    #General - highest level
    text "Kolej Sains Kesihatan Bersekutu Johor Bahru", :align => :left, :size => 12, :style => :bold
    text "#{I18n.t('position.index')} #{I18n.t('position.general')}", :align => :left, :size => 12, :style => :bold
    move_down 20
    org_chart
    #cnt=0
    
    #Academic
    start_new_page
    text "Kolej Sains Kesihatan Bersekutu Johor Bahru", :align => :left, :size => 12, :style => :bold
    text " #{I18n.t('position.index')} #{I18n.t('position.academic')}" , :align => :left, :size => 12, :style => :bold
    @pengurusan_tertinggi=@positions.at_depth(1).where('name ILIKE(?)', '%Akademik%').first
    org_chart_high_level
    
    #Academic-HEP
    start_new_page
    text "Kolej Sains Kesihatan Bersekutu Johor Bahru", :align => :left, :size => 12, :style => :bold
    text " #{I18n.t('position.index')} #{I18n.t('position.academic')} - Hal Ehwal Pelatih" , :align => :left, :size => 12, :style => :bold
    @pengurusan_tertinggi=@positions.at_depth(1).where('name ILIKE(?)', '%Hal Ehwal Pelatih%').first
    org_chart_high_level
    
    #Academic-KUPK
    start_new_page
    text "Kolej Sains Kesihatan Bersekutu Johor Bahru", :align => :left, :size => 12, :style => :bold
    text " #{I18n.t('position.index')} #{I18n.t('position.academic')} - Unit Penilaian & Kualiti" , :align => :left, :size => 12, :style => :bold
    @pengurusan_tertinggi=@positions.at_depth(1).where('name ILIKE(?)', '%Kualiti%').first
    org_chart_high_level
    
    #Management high-level
    start_new_page
    text "Kolej Sains Kesihatan Bersekutu Johor Bahru", :align => :left, :size => 12, :style => :bold
    text " #{I18n.t('position.index')} #{I18n.t('position.management')}" , :align => :left, :size => 12, :style => :bold
    @pengurusan_tertinggi=@positions.at_depth(1).where('name ILIKE(?)', '%Pengurusan%').first
    org_chart_high_level
    
    #Management UNIT part
    mgmt_leader=@positions.at_depth(1).where('name ILIKE(?)', '%Pengurusan%').first
    mgmt_leader.children.each do |unit_leader|
      unit_leader.children.each do |sub_unit_leader|
        if sub_unit_leader.children.count > 0
          start_new_page
          text "Kolej Sains Kesihatan Bersekutu Johor Bahru", :align => :left, :size => 12, :style => :bold
          text " #{I18n.t('position.index')} #{I18n.t('position.management')} " , :align => :left, :size => 12, :style => :bold
          text "#{sub_unit_leader.combo_code}  #{sub_unit_leader.name}", :align => :left, :size => 12, :style => :bold
          @unit_leader=sub_unit_leader
          org_chart_management_low_level
        end
      end
    end
    
    #Academic Subset part (if any)
    mgmt_leader=@positions.at_depth(1).where('name ILIKE(?)', '%Akademik%').first
    mgmt_leader.children.each do |unit_leader|
      unit_leader.children.each do |sub_unit_leader|
        if sub_unit_leader.children.count > 0
          start_new_page
          text "Kolej Sains Kesihatan Bersekutu Johor Bahru", :align => :left, :size => 12, :style => :bold
          text " #{I18n.t('position.index')} #{I18n.t('position.academic')} " , :align => :left, :size => 12, :style => :bold
          text "#{sub_unit_leader.combo_code}  #{sub_unit_leader.name}", :align => :left, :size => 12, :style => :bold
          @unit_leader=sub_unit_leader
          org_chart_management_low_level
        end
      end
    end
    
  end
  
  def org_chart
    upper=bounds.top-30
    bounding_box([bounds.left, upper], :width  => bounds.width, :height => bounds.height-20) do    
      stroke_bounds
      #text "#{bounds.width}"
      #text "#{bounds.height}"
    end
    
    #level 0 - Pengarah's box
    bounding_box([bounds.width/2-38, upper-10], :width => 80, :height => 30) do
      #transparent(0.3) {stroke_bounds}
      stroke_bounds
      move_down 2
      text "<b>#{@positions.first.combo_code}</b> <br>", :size => 8, :inline_format => true, :align => :center
      text @positions.first.name, :size => 8, :inline_format => true, :align => :center
    end
    
    #level 0 - PA Pengarah's box 
    if @pa.count > 0
      bounding_box([bounds.width/2-38- 120, upper-20], :width => 80, :height => 30) do
        transparent(1) {dash(1); stroke_bounds}
        move_down 2
        text "<b>#{@pa.first.combo_code}</b><br>", :size => 8, :inline_format => true, :align => :center
        text "#{@pa.first.name}", :size => 8, :inline_format => true, :align => :center
      end 
      #horizontal_line (bounds.width/2), (bounds.width/2- 40), :at => upper-30
      bounding_box([bounds.width/2-38-40, upper-30], :width => 40, :height => 30) do
	transparent(1) {dash(1); stroke_horizontal_rule}
      end
    end

    #Pengarah to surbodinate lines
    bounding_box([bounds.width/2-38, upper-40], :width => 80, :height => 30) do
      vertical_line 10, 30, :at => bounds.width/2
    end
    #horizontal_line 45, 745, :at => 449
    stroke do
      if @positions.at_depth(1).count>=8 
        horizontal_line 45, 745, :at => 449
        @move_right=0
      else
        total_count=8-@positions.at_depth(1).count
        #horizontal_line 45, 745-(total_count*100), :at => 449
        @move_right=100*total_count/2
        horizontal_line @move_right+45, @move_right+745-(total_count*100), :at =>449
      end
    end
    
    #########1st level-limit to 8 items
    @positions.at_depth(1).each_with_index do |par, cnt|
      if cnt < 8
        frleft=@move_right+10+(2*cnt*50)
        if par.name && par.name.size <= 20
          hh=30 
          hh2=50
        end
        if par.name && par.name.size > 20
          hh=60 
          hh2=80
        end
        bounding_box([frleft, upper-80], :width => 70, :height => hh) do
          stroke_bounds
          move_down 2
          text "<b>#{par.try(:combo_code)}</b> <br>"+par.try(:name), :size => 8, :inline_format => true, :align => :center, :overflow => :mode
          stroke do
            vertical_line hh, hh2, :at => bounds.width/2
          end
        end
        bounding_box([frleft, upper-150], :width => 70, :height => 400) do
          cnt2=0
          for par2 in par.children.order(combo_code: :asc)
            text "<b>#{par2.try(:combo_code)}</b>", :size => 8, :inline_format => true, :align => :center, :overflow => :mode if cnt2 < 10    
            text par2.try(:name), :size => 8, :inline_format => true, :align => :center, :overflow => :mode if cnt2 < 10
            move_down 5
            cnt2+=1
          end
        end
      end
    end

  end
  
  def org_chart_high_level
    upper=bounds.top-30
    bounding_box([bounds.left, upper], :width  => bounds.width, :height => bounds.height-20) do    
      stroke_bounds
      #text "#{bounds.width}"
      #text "#{bounds.height}"
    end
    
    #level 0 - Pengarah's box
    bounding_box([bounds.width/2-38, upper-10], :width => 80, :height => 30) do
      stroke_bounds
      move_down 2
      text "<b>#{@positions.first.combo_code}</b><br>", :size => 8, :inline_format => true, :align => :center
      text @positions.first.name, :size => 8, :inline_format => true, :align => :center
    end
    
    #level 0 - PA Pengarah's box 
    if @pa.count > 0 && @pengurusan_tertinggi.name.include?("Pengurusan")
      bounding_box([bounds.width/2-38- 120, upper-20], :width => 80, :height => 30) do
        transparent(1) {dash(1); stroke_bounds}
        move_down 2
        text "<b>#{@pa.first.combo_code}</b><br>", :size => 8, :inline_format => true, :align => :center
        text "#{@pa.first.name}", :size => 8, :inline_format => true, :align => :center
      end 
      #horizontal_line (bounds.width/2), (bounds.width/2- 40), :at => upper-30
      bounding_box([bounds.width/2-38-40, upper-30], :width => 40, :height => 30) do
        transparent(1) {dash(1); stroke_horizontal_rule}
      end
    end
    
    #Pengarah to surbodinate lines
    bounding_box([bounds.width/2-38, upper-40], :width => 80, :height => 30) do
      vertical_line 10, 30, :at => bounds.width/2
    end
    
    #level 1-Timb Pengarah Pengurusan
    bounding_box([bounds.width/2-38, upper-60], :width => 80, :height => 40) do
      stroke_bounds
      move_down 2
      text "<b>#{@pengurusan_tertinggi.combo_code}</b><br>", :size => 8, :inline_format => true, :align => :center
      text @pengurusan_tertinggi.name, :size => 8, :inline_format => true, :align => :center
    end

    #Timb Pengarah(P) to surbodinate lines
    bounding_box([bounds.width/2-38, upper-100], :width => 80, :height => 20) do 
      stroke do
        vertical_line 0,20, :at => bounds.width/2
      end 
    end
    #stroke do
    #  horizontal_line 45, 745, :at =>upper-120
    #end
    stroke do
      if @pengurusan_tertinggi.children.count>=8 
        horizontal_line 45, 745, :at =>upper-120
        @move_right=0
      else
        total_count=8-@pengurusan_tertinggi.children.count
        #horizontal_line 45, 745-(total_count*100), :at =>upper-120
        @move_right=100*total_count/2
        horizontal_line @move_right+45, @move_right+745-(total_count*100), :at =>upper-120
      end
    end
    
    #########1st level-limit to 8 items - high level
    @pengurusan_tertinggi.children.order(combo_code: :asc).each_with_index do |par, cnt|
      if cnt < 8
        frleft=@move_right+10+(2*cnt*50)
        if par.name && par.name.size <= 20
          hh=30
          hh2=50
          hh3=285
          hh4=305
        end
        if par.name && par.name.size > 20
          hh=45
          hh2=65
          hh3=285
          hh4=295
        end
        bounding_box([frleft, upper-140], :width => 70, :height => hh) do
          stroke_bounds
          move_down 2
          text "<b> #{par.try(:combo_code)}</b><br>"+par.try(:name), :size => 8, :inline_format => true, :align => :center, :overflow => :mode
          stroke do
            vertical_line hh, hh2, :at => bounds.width/2
          end
        end
	#stroke do
	#  vertical_line hh3, hh4, :at => frleft+35
	#end
         bounding_box([frleft, upper-195], :width => 70, :height => 400) do
        cnt2=0
          for par2 in par.children.order(combo_code: :asc)
            text "<b>#{par2.try(:combo_code)}</b>", :size => 8, :inline_format => true, :align => :center, :overflow => :mode if cnt2 < 10
            text par2.try(:name), :size => 8, :inline_format => true, :align => :center, :overflow => :mode if cnt2 < 10
            move_down 5
            cnt2+=1
          end
        end
      end
    end
    #****
     
  end
  
  def org_chart_management_low_level
    upper=bounds.top-40
    bounding_box([bounds.left, upper], :width  => bounds.width, :height => bounds.height-20) do    
      stroke_bounds
    end
 
    bounding_box([bounds.width/2-38, upper-40], :width => 80, :height => 30) do
      stroke_bounds
      move_down 2
      text "<b>#{@unit_leader.combo_code}</b><br>", :size => 8, :inline_format => true, :align => :center
      text @unit_leader.name, :size => 8, :inline_format => true, :align => :center
    end

    #surbodinate lines
    bounding_box([bounds.width/2-38, upper-80], :width => 80, :height => 20) do 
      stroke do
        vertical_line 20,30, :at => bounds.width/2
      end 
    end
    stroke do
      if @unit_leader.children.count>=8 
        horizontal_line 45, 745, :at =>upper-80 
        @move_right=0
      else
        total_count=8-@unit_leader.children.count
        @move_right=100*total_count/2
        horizontal_line @move_right+45, @move_right+745-(total_count*100), :at =>upper-80 
      end
    end
    
    #########1st level-limit to 8 items - unit members
    @unit_leader.children.order(combo_code: :asc).each_with_index do |par, cnt|
      if cnt < 8 
        frleft=@move_right+10+(2*cnt*50)
        if par.name && par.name.size <= 20
          hh=30
          hh2=50
        end
        if par.name && par.name.size > 20
          hh=40
          hh2=60
        end
        bounding_box([frleft, upper-100], :width => 70, :height => hh) do
          stroke_bounds
          move_down 2
          text par.try(:combo_code)+"<br>"+par.try(:name), :size => 8, :inline_format => true, :align => :center, :overflow => :mode
          stroke do
            vertical_line hh, hh2, :at => bounds.width/2
          end
        end
        #stroke do
        #  vertical_line hh3, hh4, :at => frleft+35
        #end
        bounding_box([frleft, upper-150], :width => 70, :height => 400) do
          cnt2=0
          for par2 in par.children.order(combo_code: :asc)
            text "<b>#{par2.try(:combo_code)}</b>", :size => 8, :inline_format => true, :align => :center, :overflow => :mode if cnt2 < 10
            text par2.try(:name), :size => 8, :inline_format => true, :align => :center, :overflow => :mode if cnt2 < 10
            move_down 5
            cnt2+=1
          end
        end
      end
    end
    #****
  end
  
end