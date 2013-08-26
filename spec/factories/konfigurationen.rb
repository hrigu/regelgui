# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :konfiguration do
    gruen_untere_grenze 1
    orange_untere_grenze 1
    rot_untere_grenze 1
    gruen_obere_grenze 1
    orange_obere_grenze 1
    rot_obere_grenze 1
    gruenorangerot_position 1
    type ""
  end
end
