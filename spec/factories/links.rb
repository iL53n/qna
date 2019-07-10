FactoryBot.define do
  factory :link do
    name { "Link" }
    url { "https://google.com" }

    trait :gist do
      name { "GistLink" }
      url { "https://gist.github.com/iL53n/0acd40b1345c1bafa854c6efb8a93a47" }
    end
  end
end
