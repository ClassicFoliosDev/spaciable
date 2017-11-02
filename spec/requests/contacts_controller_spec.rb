# frozen_string_literal: true

require "rails_helper"

RSpec.describe ContactsController do
  describe "#index" do
    context "as a DeveloperAdmin" do
      context "for a developer contact" do
        it "should return ok" do
          admin = create(:developer_admin)
          login_as admin
          get url_for([admin.permission_level, :contacts])

          expect(response.status).to eq(200)
        end
      end

      context "for a division contact" do
        it "should return ok" do
          admin = create(:developer_admin)
          division = create(:division, developer: admin.permission_level)

          login_as admin
          get url_for([division, :contacts])

          expect(response.status).to eq(200)
        end
      end

      context "for a development contact" do
        it "should return ok" do
          admin = create(:developer_admin)
          development = create(:development, developer: admin.permission_level)

          login_as admin
          get url_for([development, :contacts])

          expect(response.status).to eq(200)
        end
      end
    end

    context "as a DivisionAdmin" do
      context "for a developer contact" do
        it "should redirect to the root url" do
          admin = create(:division_admin)
          login_as admin
          get url_for([admin.permission_level.developer, :contacts])

          expect(response.status).to eq(200)
        end
      end

      context "for a division contact" do
        it "should return ok" do
          admin = create(:division_admin)

          login_as admin
          get url_for([admin.permission_level, :contacts])

          expect(response.status).to eq(200)
        end
      end

      context "for a development contact" do
        it "should return ok" do
          admin = create(:division_admin)
          division_development = create(:division_development, division: admin.permission_level)

          login_as admin
          get url_for([division_development, :contacts])

          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe "#new" do
    context "as a DeveloperAdmin" do
      context "for a developer contact" do
        it "should return ok" do
          admin = create(:developer_admin)
          login_as admin
          get url_for([:new, admin.permission_level, :contact])

          expect(response.status).to eq(200)
        end
      end

      context "for a division contact" do
        it "should return ok" do
          admin = create(:developer_admin)
          division = create(:division, developer: admin.permission_level)

          login_as admin
          get url_for([:new, division, :contact])

          expect(response.status).to eq(200)
        end
      end

      context "for a development contact" do
        it "should return ok" do
          admin = create(:developer_admin)
          development = create(:development, developer: admin.permission_level)

          login_as admin
          get url_for([:new, development, :contact])

          expect(response.status).to eq(200)
        end
      end
    end

    context "as a DivisionAdmin" do
      context "for a developer contact" do
        it "should redirect to the root url" do
          admin = create(:division_admin)
          login_as admin
          get url_for([:new, admin.permission_level.developer, :contact])

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division contact" do
        it "should return ok" do
          admin = create(:division_admin)

          login_as admin
          get url_for([:new, admin.permission_level, :contact])

          expect(response.status).to eq(200)
        end
      end

      context "for a development contact" do
        it "should return ok" do
          admin = create(:division_admin)
          division_development = create(:division_development, division: admin.permission_level)

          login_as admin
          get url_for([:new, division_development, :contact])

          expect(response.status).to eq(200)
        end
      end
    end

    context "as a DevelopmentAdmin" do
      context "for a developer contact" do
        it "should redirect to the root url" do
          admin = create(:development_admin)
          login_as admin
          get url_for([:new, admin.permission_level.developer, :contact])

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division contact" do
        it "should redirect to the root url" do
          division_development = create(:division_development)
          admin = create(:development_admin, permission_level: division_development)

          login_as admin
          get url_for([:new, admin.permission_level.division, :contact])

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a development contact" do
        it "should return ok" do
          admin = create(:development_admin)

          login_as admin
          get url_for([:new, admin.permission_level, :contact])

          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe "#create" do
    let(:params) { { params: { contact: { name: "" } } } }

    context "as a DeveloperAdmin" do
      context "for a developer contact" do
        it "should return ok" do
          admin = create(:developer_admin)
          login_as admin
          post url_for([admin.permission_level, :contacts]), params: params

          expect(response.status).to eq(200)
        end
      end

      context "for a division contact" do
        it "should return ok" do
          admin = create(:developer_admin)
          division = create(:division, developer: admin.permission_level)

          login_as admin
          post url_for([division, :contacts]), params: params

          expect(response.status).to eq(200)
        end
      end

      context "for a development contact" do
        it "should return ok" do
          admin = create(:developer_admin)
          development = create(:development, developer: admin.permission_level)

          login_as admin
          post url_for([development, :contacts]), params: params

          expect(response.status).to eq(200)
        end
      end
    end

    context "as a DivisionAdmin" do
      context "for a developer contact" do
        it "should redirect to the root url" do
          admin = create(:division_admin)
          login_as admin
          post url_for([admin.permission_level.developer, :contacts]), params: params

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division contact" do
        it "should return ok" do
          admin = create(:division_admin)

          login_as admin
          post url_for([admin.permission_level, :contacts]), params: params

          expect(response.status).to eq(200)
        end
      end

      context "for a development contact" do
        it "should return ok" do
          admin = create(:division_admin)
          division_development = create(:division_development, division: admin.permission_level)

          login_as admin
          post url_for([division_development, :contacts]), params: params

          expect(response.status).to eq(200)
        end
      end
    end

    context "as a DevelopmentAdmin" do
      context "for a developer contact" do
        it "should redirect to the root url" do
          admin = create(:development_admin)
          login_as admin
          post url_for([admin.permission_level.developer, :contacts]), params: params

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division contact" do
        it "should redirect to the root url" do
          division_development = create(:division_development)
          admin = create(:development_admin, permission_level: division_development)

          login_as admin
          post url_for([admin.permission_level.division, :contacts]), params: params

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a development contact" do
        it "should return ok" do
          admin = create(:development_admin)

          login_as admin
          post url_for([admin.permission_level, :contacts]), params: params

          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe "#edit" do
    context "as a DeveloperAdmin" do
      context "for a developer contact" do
        it "should return ok" do
          admin = create(:developer_admin)
          contact = create(:contact, contactable: admin.permission_level)

          login_as admin
          get url_for([:edit, contact])

          expect(response.status).to eq(200)
        end
      end

      context "for a division contact" do
        it "should return ok" do
          admin = create(:developer_admin)
          division = create(:division, developer: admin.permission_level)
          contact = create(:contact, contactable: division)

          login_as admin
          get url_for([:edit, contact])

          expect(response.status).to eq(200)
        end
      end

      context "for a development contact" do
        it "should return ok" do
          admin = create(:developer_admin)
          development = create(:development, developer: admin.permission_level)
          contact = create(:contact, contactable: development)

          login_as admin
          get url_for([:edit, contact])

          expect(response.status).to eq(200)
        end
      end
    end

    context "as a DivisionAdmin" do
      context "for a developer contact" do
        it "should redirect to the root url" do
          admin = create(:division_admin)
          contact = create(:contact, contactable: admin.permission_level.developer)

          login_as admin
          get url_for([:edit, contact])

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division contact" do
        it "should return ok" do
          admin = create(:division_admin)
          contact = create(:contact, contactable: admin.permission_level)

          login_as admin
          get url_for([:edit, contact])

          expect(response.status).to eq(200)
        end
      end

      context "for a development contact" do
        it "should return ok" do
          admin = create(:division_admin)
          division_development = create(:division_development, division: admin.permission_level)
          contact = create(:contact, contactable: division_development)

          login_as admin
          get url_for([:edit, contact])

          expect(response.status).to eq(200)
        end
      end
    end

    context "as a DevelopmentAdmin" do
      context "for a developer contact" do
        it "should redirect to the root url" do
          admin = create(:development_admin)
          contact = create(:contact, contactable: admin.permission_level.developer)

          login_as admin
          get url_for([:edit, contact])

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division contact" do
        it "should redirect to the root url" do
          division_development = create(:division_development)
          admin = create(:development_admin, permission_level: division_development)
          contact = create(:contact, contactable: division_development.division)

          login_as admin
          get url_for([:edit, contact])

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a development contact" do
        it "should return ok" do
          admin = create(:development_admin)
          contact = create(:contact, contactable: admin.permission_level)

          login_as admin
          get url_for([:edit, contact])

          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe "#update" do
    let(:params) { { params: { contact: { name: "" } } } }

    context "as a DeveloperAdmin" do
      context "for a developer contact" do
        it "should return ok" do
          admin = create(:developer_admin)
          contact = create(:contact, contactable: admin.permission_level)

          login_as admin
          put url_for(contact), params: params

          expect(response.redirect_url).not_to eq(root_url)
        end
      end

      context "for a division contact" do
        it "should return ok" do
          admin = create(:developer_admin)
          division = create(:division, developer: admin.permission_level)
          contact = create(:contact, contactable: division)

          login_as admin
          put url_for(contact), params: params

          expect(response.redirect_url).not_to eq(root_url)
        end
      end

      context "for a development contact" do
        it "should return ok" do
          admin = create(:developer_admin)
          development = create(:development, developer: admin.permission_level)
          contact = create(:contact, contactable: development)

          login_as admin
          put url_for(contact), params: params

          expect(response.redirect_url).not_to eq(root_url)
        end
      end
    end

    context "as a DivisionAdmin" do
      context "for a developer contact" do
        it "should redirect to the root url" do
          admin = create(:division_admin)
          contact = create(:contact, contactable: admin.permission_level.developer)

          login_as admin
          put url_for(contact), params: params

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division contact" do
        it "should return ok" do
          admin = create(:division_admin)
          contact = create(:contact, contactable: admin.permission_level)

          login_as admin
          put url_for(contact), params: params

          expect(response.redirect_url).not_to eq(root_url)
        end
      end

      context "for a development contact" do
        it "should return ok" do
          admin = create(:division_admin)
          division_development = create(:division_development, division: admin.permission_level)
          contact = create(:contact, contactable: division_development)

          login_as admin
          put url_for(contact), params: params

          expect(response.redirect_url).not_to eq(root_url)
        end
      end
    end

    context "as a DevelopmentAdmin" do
      context "for a developer contact" do
        it "should redirect to the root url" do
          admin = create(:development_admin)
          contact = create(:contact, contactable: admin.permission_level.developer)

          login_as admin
          put url_for(contact), params: params

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division contact" do
        it "should redirect to the root url" do
          division_development = create(:division_development)
          admin = create(:development_admin, permission_level: division_development)
          contact = create(:contact, contactable: division_development.division)

          login_as admin
          put url_for(contact), params: params

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a development contact" do
        it "should return ok" do
          admin = create(:development_admin)
          contact = create(:contact, contactable: admin.permission_level)

          login_as admin
          put url_for(contact), params: params

          expect(response.redirect_url).not_to eq(root_url)
        end
      end
    end
  end

  describe "#destroy" do
    context "as a DeveloperAdmin" do
      context "for a developer contact" do
        it "should return ok" do
          admin = create(:developer_admin)
          contact = create(:contact, contactable: admin.permission_level)

          login_as admin
          delete url_for(contact)

          expect(response.redirect_url).not_to eq(root_url)
        end
      end

      context "for a division contact" do
        it "should return ok" do
          admin = create(:developer_admin)
          division = create(:division, developer: admin.permission_level)
          contact = create(:contact, contactable: division)

          login_as admin
          delete url_for(contact)

          expect(response.redirect_url).not_to eq(root_url)
        end
      end

      context "for a development contact" do
        it "should return ok" do
          admin = create(:developer_admin)
          development = create(:development, developer: admin.permission_level)
          contact = create(:contact, contactable: development)

          login_as admin
          delete url_for(contact)

          expect(response.redirect_url).not_to eq(root_url)
        end
      end
    end

    context "as a DivisionAdmin" do
      context "for a developer contact" do
        it "should redirect to the root url" do
          admin = create(:division_admin)
          contact = create(:contact, contactable: admin.permission_level.developer)

          login_as admin
          delete url_for(contact)

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division contact" do
        it "should return ok" do
          admin = create(:division_admin)
          contact = create(:contact, contactable: admin.permission_level)

          login_as admin
          delete url_for(contact)

          expect(response.redirect_url).not_to eq(root_url)
        end
      end

      context "for a development contact" do
        it "should return ok" do
          admin = create(:division_admin)
          division_development = create(:division_development, division: admin.permission_level)
          contact = create(:contact, contactable: division_development)

          login_as admin
          delete url_for(contact)

          expect(response.redirect_url).not_to eq(root_url)
        end
      end
    end

    context "as a DevelopmentAdmin" do
      context "for a developer contact" do
        it "should redirect to the root url" do
          admin = create(:development_admin)
          contact = create(:contact, contactable: admin.permission_level.developer)

          login_as admin
          delete url_for(contact)

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division contact" do
        it "should redirect to the root url" do
          division_development = create(:division_development)
          admin = create(:development_admin, permission_level: division_development)
          contact = create(:contact, contactable: division_development.division)

          login_as admin
          delete url_for(contact)

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a development contact" do
        it "should return ok" do
          admin = create(:development_admin)
          contact = create(:contact, contactable: admin.permission_level)

          login_as admin
          delete url_for(contact)

          expect(response.redirect_url).not_to eq(root_url)
        end
      end
    end
  end
end
