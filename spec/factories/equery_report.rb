FactoryGirl.define do
  
  #repositorysearch
  factory :repositorysearch do
    sequence(:keyword) {|n| "Some Keyword_#{n}"}
    college_id 1
    data {{}}
  end

end