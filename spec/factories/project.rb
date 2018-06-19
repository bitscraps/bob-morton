FactoryBot.define do
  factory :project do
    trait :bob_morton do
      github_project_user 'bitscraps'
      github_project_name 'bob-morton'
    end
  end
end
