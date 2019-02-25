# Preview all emails at http://localhost:3000/rails/mailers/example_mailer
class ReleaseMailerPreview < ActionMailer::Preview
  def reservation_release_email
    ReleaseMailer. reservation_release_email(User.first)
  end
end