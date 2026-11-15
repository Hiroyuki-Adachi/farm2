FactoryBot.define do
  factory :work_result do
    work
    worker
    hours { 6 }
    display_order { 1 }
  end
end
