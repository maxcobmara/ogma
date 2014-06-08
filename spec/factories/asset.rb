FactoryGirl.define do
  
  # Assets
  factory :asset do
    sequence(:assetcode) { |n| "KKM/BPL/010619/H/10/1#{n}" }
  end

end