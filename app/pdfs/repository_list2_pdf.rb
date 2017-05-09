class Repository_list2Pdf < Prawn::Document
  def initialize(repositories, view, college, per_vessel, per_vessel_count_arr2)
    super({top_margin: 30, left_margin: 40, page_size: 'A4', page_layout: :landscape })
    @repositories = repositories
    @view = view
    @college=college
    @per_vessel=per_vessel
    @per_vessel_count_arr2=per_vessel_count_arr2
    font "Helvetica"
    record
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  def record
    ##########
    cnt=0
    no=0
    a=2
    doctype=""
    subdoctype=""
    subdoctype2=""
    vessel_row=[]
    doctype_row=[]
    subdoctype_row=[]
    counting2=1
    
    for repository in @repositories
        #vessel row
        @per_vessel_count_arr2.each_with_index do |x, ind|
          if x==no
            counting2+=1
            vessel_row << counting2
            doctype=""
            subdoctype=""
            subdoctype2=""
           end
        end
        
        #1b-rescue for pages w/o heading (vessel name) before the first record - start
#         if cnt==0 && @per_vessel_count_arr2.include?(no)==false
#           checker=0
#           @per_vessel_count_arr2.each_with_index do |x, ind|
#             if x > no && checker==0
#               checker+=1
# 	      counting2+=1
# 	      #body << [{content: "#{vessel_sort[ind-1]}<br>#{(I18n.t 'repositories.continued_from')}", colspan: 10}]
# 	      #vessel_row << cnt
#             end
#           end
#         end
        #rescue for pages w/o heading (vessel name) before the first record - end 
        
        #document_type row
        if repository.render_document!= doctype
          doctype=repository.render_document
          counting2+=1
          doctype_row << counting2
          #subdocument_type row
          if repository.render_subdocument!= subdoctype
            subdoctype=repository.render_subdocument
            counting2+=1
            subdoctype_row << counting2
          else
            counting2+=1
            subdoctype_row << counting2
          end
        else
          if repository.render_subdocument!= subdoctype
            subdoctype=repository.render_subdocument
            counting2+=1
            subdoctype_row << counting2
          end
        end
        counting2+=1
        no+=1
        cnt+=1
    end
    ##########
    
    table(line_item_rows, :column_widths => [30, 195, 130, 80, 80, 55, 85, 110] , :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=30
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      column(5).align = :center
      column(8).align = :center
      0.upto(vessel_row.count-1).each do |counting|
        row(vessel_row[counting]).align = :center
        row(vessel_row[counting]).font_style = :bold
        row(vessel_row[counting]).background_color='f8dd78' #'fcbb51'
        row(vessel_row[counting]).text_color = '565656'
      end
      0.upto(doctype_row.count-1).each do |counting|
        row(doctype_row[counting]).align = :center
        row(doctype_row[counting]).font_style = :bold
        row(doctype_row[counting]).background_color='f8dd78' #'fccc7d'
      end
      0.upto(subdoctype_row.count-1).each do |counting|
        row(subdoctype_row[counting]).align = :center
        row(subdoctype_row[counting]).font_style = :bold
        row(subdoctype_row[counting]).background_color='f8dd78' #'ffe3b5'
        row(subdoctype_row[counting]).text_color = '0516de'
      end
    end
  end
  
  def line_item_rows
    vessel_sort=[]
    @per_vessel.each{|vess| vessel_sort << vess[0]}
      
    counting2=1
    cnt=0
    no=0
    
    #starting value for document_type(BRs, Drawings, Test & Trials) & subdocument_type(systems)
    doctype=""
    subdoctype=""
    subdoctype2=""
    ####
    
    header = [[{content: "#{I18n.t('repositories.list2')}", colspan: 8}], [ 'No',  I18n.t('repositories.document_title'), I18n.t('repositories.refno'), I18n.t('repositories.publish_date'), I18n.t('repositories.location'), I18n.t('repositories.master'), I18n.t('repositories.classification'), I18n.t('repositories.uploaded')]]
    #I18n.t('repositories.document_type'), I18n.t('repositories.document_subtype'),   I18n.t('repositories.vessel'),
    #"#{I18n.t('repositories.copies')} / #{I18n.t('repositories.total_pages')}"
    
    body=[]
    for repository in @repositories
        
        #####HEADING - vessel, document_type, document_group - start
        #1) heading - vessel (name)
        #1a-display heading (vessel name) - before first record of each vessel - start
        @per_vessel_count_arr2.each_with_index do |x, ind|
          if x==no
            counting2+=1
            body << [{content: "#{vessel_sort[ind]}", colspan: 8}]
            #reset value for document_type(BRs, Drawings, Test & Trials) & subdocument_type(systems) - for every NEW vessel
            doctype=""
            subdoctype=""
            subdoctype2=""
           end
        end
        #display heading (vessel name) - before first record of each vessel - end
        
        #1b-rescue for pages w/o heading (vessel name) before the first record - start
        if cnt==0 && @per_vessel_count_arr2.include?(no)==false
          checker=0
          @per_vessel_count_arr2.each_with_index do |x, ind|
            if x > no && checker==0
              checker+=1
              counting2+=1
              body << [{content: "#{vessel_sort[ind-1]}<br>#{(I18n.t 'repositories.continued_from')}", colspan: 10}]
            end
          end
        end
        #rescue for pages w/o heading (vessel name) before the first record - end 
        
        #2) heading - document_type (BRs, Drawings, Test & Trials) & subdocument_type (system)
        if repository.render_document!= doctype
          doctype=repository.render_document
          counting2+=1
          body << [{content: "#{doctype}", colspan: 8}]
          if repository.render_subdocument!= subdoctype
            subdoctype=repository.render_subdocument
            counting2+=1
            body << [{content: "#{subdoctype} #{counting2}", colspan: 8}]
          else
            counting2+=1
            body << [{content: "#{subdoctype} #{counting2}", colspan: 8}]
          end
        else
          if repository.render_subdocument!= subdoctype
            counting2+=1
            subdoctype=repository.render_subdocument
            body << [{content: "#{subdoctype} #{counting2}", colspan: 8}]
          end
        end
        #####HEADING - vessel, document_type, document_group - end
        no+=1
        cnt+=1
        counting2+=1

        body << ["#{cnt}", repository.title, repository.refno, repository.publish_date, repository.location, "#{repository.vessel.blank? ? '/' : 'X' }",repository.render_classification, repository.uploaded_file_name]
      end
      #repository.render_document, repository.render_subdocument, repository.vessel,
      #"#{repository.copies} / #{repository.total_pages}"
      header+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [750,-5]
  end

end