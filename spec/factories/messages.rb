FactoryGirl.define do

  factory :message do
    body  { Faker::Lorem.sentence }
    image { fixture_file_upload("#{::Rails.root}/spec/fixtures/img/sample.jpg", "image/jpeg") }
  end

end
