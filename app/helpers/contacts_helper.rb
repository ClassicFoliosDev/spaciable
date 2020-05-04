# frozen_string_literal: true

module ContactsHelper
  def contact_titles_collection
    Contact.titles.map do |(title_name, _title_int)|
      [t(title_name, scope: titles_scope), title_name]
    end
  end

  def contact_categories_collection
    Contact.categories.map do |(category_name, _category_int)|
      [t(category_name, scope: categories_scope), category_name]
    end
  end

  def contact_types_collection
    Contact.contact_types.map do |(cat_type_name, _cat_type_int)|
      [t(cat_type_name, scope: cat_type_scope), cat_type_name]
    end
  end

  private

  def titles_scope
    "activerecord.attributes.contact.titles"
  end

  def categories_scope
    "activerecord.attributes.contact.categories"
  end

  def cat_type_scope
    "activerecord.attributes.contact.contact_types"
  end
end
