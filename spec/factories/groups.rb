FactoryGirl.define do

  factory :group do
    sequence :name do |n|
      "group#{n}"
    end
  end

end
