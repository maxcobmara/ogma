FactoryGirl.define do

  # Assets
  factory :asset do
    sequence(:assetcode) { |n| "1#{n}" }
  end

  factory :fixed_asset, class: 'Asset' do
    sequence(:assetcode) { |n| "KKM/BPL/010619/H/10/1#{n}" }
    assettype 1
  end

  factory :inventory, class: 'Asset'  do
    sequence(:assetcode) { |n| "KKM/BPL/010619/I/10/1#{n}" }
    assettype 2
  end


  factory :asset_defect do
    association :asset, factory: :fixed_asset
    association :reporter, factory: :staff
  end

  factory :asset_disposal do
    association :asset, factory: :fixed_asset
    current_value 1
  end

  factory :stationery do
    #category "some_name"
    #code "some_code"
    sequence(:category) { |n| "category#{n}" }
    sequence(:code) { |n| "code#{n}" }
  end

end
