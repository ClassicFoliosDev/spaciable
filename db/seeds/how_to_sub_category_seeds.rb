{
"Around the Home": [
  "Bathroom Ideas",
  "Bedroom Ideas",
  "Flooring Ideas",
  "Home Tips",
  "Kitchen Ideas",
  "Lounge Ideas"],
"Cleaning": [
  "By Room",
  "Furnishings",
  "Green",
  "Laundry",
  "Outdoors",
  "Surfaces"],
"DIY": [
  "Carpentry",
  "Decorating",
  "Electrics",
  "Exterior",
  "Home Care",
  "Plumbing"],
"Lifestyle": [
  "Design Ideas",
  "Family",
  "Green Ideas",
  "Healthy Living",
  "Hobbies",
  "Legal"],
"Outdoors": [
  "Design Ideas",
  "Gardens",
  "Grow Your Own",
  "Out & About",
  "Plants",
  "Seasons"],
"Recipes": [
  "Beverages",
  "Healthy Diet",
  "Main Ingredient",
  "Meals & Courses",
  "Occasions",
  "World Food"
]}.each_pair do |parent_name, sub_category_names|
  sub_category_names.each do | sub_category_name |
    sub_category = HowToSubCategory.find_or_initialize_by(parent_category: parent_name, name: sub_category_name)

    if sub_category.new_record?
      puts "HowTo SubCategory: #{sub_category_name} #{parent_name}"
    end

    sub_category.parent_category = parent_name
    sub_category.save!
  end
end
