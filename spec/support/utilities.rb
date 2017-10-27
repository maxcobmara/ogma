def sign_in(user)
  visit root_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button I18n.t("home.sign_in") #"Sign-In"
  # Sign in when not using Capybara as well.
  #cookies[:remember_token] = user.remember_token
end

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
