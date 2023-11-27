(1..6).each do |category|
  FaqTypeCategory.create(faq_type_id: 1, faq_category_id: category)
end
(1..7).each do |category|
  FaqTypeCategory.create(faq_type_id: 2, faq_category_id: category)
end

(3..4).each do |type|
  (1..5).each do |category|
    FaqTypeCategory.create(faq_type_id: type, faq_category_id: category)
   end
end

[5,6].each do |type|
  [8,9,10,3,5].each do |category|
    FaqTypeCategory.create(faq_type_id: type, faq_category_id: category)
  end
end
