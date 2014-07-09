FactoryGirl.define do
  
  factory :programme do
    sequence(:code) { |n| "0#{n}" }
    sequence(:ancestry_depth) {|n| "#{n}"}
    #sequence(:ancesttry) { |n| "#{n}"}
    #sequence(:combo_code) { |n| "0#{n}-"+code}
  end
  
    #if programme --> course type diploma/pos basik/diploma lanjutan && ancestry depth=0
    #if programme --> course type semester ancestry_depth=1

end