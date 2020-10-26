User.all.each do |user|
  CcEmail.email_types.each do |type, index|
    CcEmail.create(user_id: user.id, email_type: type)
  end
end
