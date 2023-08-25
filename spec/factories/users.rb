FactoryBot.define do
  factory :user do
    # no id, it's autoincremented

    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 6) }

    trait :is_admin do
      admin { true }
    end

  end
end
#validari plus ce mai vreau sa vad, trait pentru control mai precis asupa generation
