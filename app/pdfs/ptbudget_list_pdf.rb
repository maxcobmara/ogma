class Ptbudget_listPdf < Prawn::Document
  def initialize(ptbudgets, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @ptbudgets = ptbudgets
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
    total_recs=@ptbudgets.count
    sum_rows=[]
    ind=0
    no=2
    @ptbudgets.group_by{|x|x.fiscal_end}.sort.reverse.each do |fiscal_ending, budgets|
      if budgets.count>1
        budgets.each do |ptbudget|
          ptbudgets_multiple_cnt=Ptbudget.where('id IN(?) and id!=?', budgets.map(&:id), ptbudget.id).order(fiscalstart: :asc).count
          sum_rows << no+1+ptbudgets_multiple_cnt
	  #ind=no+1+ptbudgets_multiple_cnt
        end
      else
      end
      no+=1
    end
    table(line_item_rows, :column_widths => [30, 170, 90, 90, 80, 60], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      row(2..total_recs+2).columns(2..5).align=:right
      self.width=520
      for sum_row in sum_rows
        row(sum_row).font_style=:bold
      end
    end
  end

  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('staff.training.budget.title').upcase}<br> #{@college.name.upcase}", colspan: 6}],
              [ 'No', I18n.t('staff.training.budget.start'), I18n.t('staff.training.budget.budget'), I18n.t('staff.training.budget.used'), I18n.t('staff.training.budget.balance'), "#{I18n.t('staff.training.budget.balance')} (%)" ]]
    body=[]
    @ptbudgets.group_by{|x|x.fiscal_end}.sort.reverse.each do |fiscal_ending, budgets|
      if budgets.count>1
        main_budget_id=0
        budgets.each do |ptbudget|
          if ptbudget.fiscalstart.month==ptbudget.budget_start.month && ptbudget.fiscalstart.day==ptbudget.budget_start.day 
            main_budget_id=ptbudget.id 
	    mainbudget="(#{@view.l(ptbudget.fiscalstart).to_s} #{I18n.t('to')} #{@view.l(ptbudget.fiscal_end)})"
	    @ptbudgets_multiple=Ptbudget.where('id IN(?) and id!=?', budgets.map(&:id), main_budget_id).order(fiscalstart: :asc)
            body << ["#{counter += 1}", mainbudget, @view.ringgols(ptbudget.budget), {content: @view.ringgols(ptbudget.used_budget), rowspan: @ptbudgets_multiple.count+1}, @view.ringgols(ptbudget.budget_balance) , @view.number_with_precision((ptbudget.budget_balance.to_f / ptbudget.budget.to_f) *  100, :precision => 2)]
            
	    cnt=cnt||0
            @ptbudgets_multiple.each do |ptbudget|
                multi_budget="(#{@view.l(ptbudget.fiscalstart).to_s} #{I18n.t('to')} #{@view.l(ptbudget.fiscal_end)})"
                body << ["(#{cnt+=1})", multi_budget, "+ #{@view.ringgols(ptbudget.budget)}", @view.ringgols(ptbudget.budget_balance), @view.number_with_precision((ptbudget.budget_balance.to_f / ptbudget.acc_budget.to_f) *  100, :precision => 2)]
            end

            heading_budget=Ptbudget.find(main_budget_id)
            all_budget_recs=Ptbudget.where('fiscalstart >=? and fiscalstart <=?', heading_budget.fiscalstart, heading_budget.fiscalstart+1.year-1.day)
            all_budget=all_budget_recs.map(&:budget).sum 
            latest_balance=all_budget-all_budget_recs[0].used_budget
	    
	    body << ["", "", @view.ringgols(all_budget), @view.ringgols(all_budget_recs[0].used_budget), @view.ringgols(latest_balance), @view.number_with_precision((latest_balance.to_f / all_budget.to_f) *  100, :precision => 2)]

          end #endof ptbudget.fis...
        end #endof budgets
      
      else
        ptbudget=budgets[0]
        budget="(#{@view.l(ptbudget.fiscalstart).to_s} #{I18n.t('to')} #{@view.l(ptbudget.fiscal_end)})"
        body << ["#{counter+=1}", budget, @view.ringgols(ptbudget.budget), @view.ringgols(ptbudget.used_budget), @view.ringgols(ptbudget.budget_balance), @view.number_with_precision(ptbudget.budget_balance_percent, :precision => 2)]
      end     
    end 

    header+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [470,-5]
  end

end