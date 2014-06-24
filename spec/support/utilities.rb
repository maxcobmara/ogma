def full_title(page_title)
  base_title = "Ogma App"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def fiscal_end(budget)
  (budget.fiscalstart + 1.year - 1.day).try(:strftime, "%d %B %Y")
end

def budget_range(budget)
  budget.fiscalstart.strftime("%d %B %Y") + ' ~ ' + fiscal_end(budget)
end

