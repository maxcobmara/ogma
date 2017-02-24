class Topicdetail_reportPdf < Prawn::Document
  def initialize(topicdetails, view, college)
    super({top_margin: 50,  page_size: 'A4', page_layout: :landscape })
    @topicdetails = topicdetails
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
    table(line_item_rows, :column_widths => [30, 175, 100, 50, 60, 50, 50, 55, 70, 120], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('training.topicdetail.list').upcase}<br> #{@college.name.upcase}", colspan: 10}],
              [ 'No', "#{I18n.t('training.topicdetail.programme')}<br> - #{@college.code=='kskbjb' ? I18n.t('training.topicdetail.subject') : I18n.t('training.programme.module')+'>'+I18n.t('training.topicdetail.subject')}", I18n.t('training.topicdetail.topic_code'), I18n.t('training.topicdetail.version_no'), I18n.t('training.topicdetail.duration'), I18n.t('training.topicdetail.theory'), I18n.t('training.topicdetail.tutorial'), I18n.t('training.topicdetail.practical'), I18n.t('training.topicdetail.training_notes'), I18n.t('training.topicdetail.prepared_by') ]]
    header +
    @topicdetails.map do |topicd|
         ["#{counter += 1}", "#{topicd.subject_topic.root.programme_list+"<br> - "}#{ @college.code=='kskbjb' ?  topicd.subject_topic.ancestors.where(course_type: "Subject").first.subject_list : topicd.subject_topic.module_subject}", topicd.subject_topic.name.titleize, topicd.version_no, topicd.subject_topic.try(:total_duration), "#{topicd.subject_topic.try(:lecture_duration) unless topicd.subject_topic.lecture_d.blank?}", "#{topicd.subject_topic.try(:tutorial_duration) unless topicd.subject_topic.tutorial_d.blank?}", "#{topicd.subject_topic.try(:practical_duration) unless topicd.subject_topic.practical_d.blank?}", "#{topicd.trainingnotes.count > 0 ? I18n.t('yes2') : I18n.t('no2')} #{'('+topicd.trainingnotes.count.to_s+')' if topicd.trainingnotes.count > 0}", "#{topicd.topic_creator.rank_id? ? topicd.topic_creator.try(:staff_with_rank) : topicd.topic_creator.try(:name)}"]
    end
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [750,-5]
  end

end