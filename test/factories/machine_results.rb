FactoryBot.define do
  factory :machine_result do
    work_result
    machine
    hours { 1 }
    display_order { 1 }
  end
end
