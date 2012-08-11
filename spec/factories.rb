FactoryGirl.define do
  factory :user do
    name "Jimmy F"
    email "jimmy@example.com"
    email_lower "jimmy@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end
