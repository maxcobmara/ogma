FactoryGirl.define do
  
  # Assets
  factory :asset do
    factory :fixed_asset do
      sequence(:assetcode) { |n| "KKM/BPL/010619/H/10/1#{n}" }
      assettype 1
    end
    
    factory :inventory do
      sequence(:assetcode) { |n| "KKM/BPL/010619/I/10/1#{n}" }
      assettype 2
    end
  end
  
  factory :asset_defect do
    association :asset, factory: :fixed_asset
  end

end