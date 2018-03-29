# frozen_string_literal: true

require "rails_helper"

RSpec.describe DocumentsController do
  describe "#index" do
    context "as a DeveloperAdmin" do
      context "for division documents" do
        it "should return ok" do
          admin = create(:developer_admin)
          division = create(:division, developer_id: admin.developer_id)

          login_as admin
          get url_for([admin.permission_level, division, active_tab: "documents"])

          expect(response.status).to eq(200)
        end
      end

      context "for development documents" do
        it "should return ok" do
          admin = create(:developer_admin)

          login_as admin
          get url_for([admin.permission_level, :developments, active_tab: "documents"])

          expect(response.status).to eq(200)
        end
      end
    end

    context "as a DivisionAdmin" do
      context "for division documents" do
        it "should return ok" do
          admin = create(:division_admin)
          division = admin.permission_level

          login_as admin
          get url_for([division.developer, division, active_tab: "documents"])

          expect(response.status).to eq(200)
        end
      end

      context "for development documents" do
        it "should return ok" do
          admin = create(:division_admin)

          login_as admin
          get url_for([admin.permission_level, :developments, active_tab: "documents"])

          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe "#new" do
    context "as a DeveloperAdmin" do
      context "for a developer document" do
        it "should return ok" do
          admin = create(:developer_admin)
          login_as admin
          get url_for([:new, admin.permission_level, :document])

          expect(response.status).to eq(200)
        end
      end

      context "for a division document" do
        it "should return ok" do
          admin = create(:developer_admin)
          division = create(:division, developer: admin.permission_level)

          login_as admin
          get url_for([:new, division, :document])

          expect(response.status).to eq(200)
        end
      end

      context "for a development document" do
        it "should return ok" do
          admin = create(:developer_admin)
          development = create(:development, developer: admin.permission_level)

          login_as admin
          get url_for([:new, development, :document])

          expect(response.status).to eq(200)
        end
      end
    end

    context "as a DivisionAdmin" do
      context "for a developer document" do
        it "should redirect to the root url" do
          admin = create(:division_admin)
          login_as admin
          get url_for([:new, admin.permission_level.developer, :document])

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division document" do
        it "should return ok" do
          admin = create(:division_admin)

          login_as admin
          get url_for([:new, admin.permission_level, :document])

          expect(response.status).to eq(200)
        end
      end

      context "for a development document" do
        it "should return ok" do
          admin = create(:division_admin)
          division_development = create(:division_development, division: admin.permission_level)

          login_as admin
          get url_for([:new, division_development, :document])

          expect(response.status).to eq(200)
        end
      end
    end

    context "as a DevelopmentAdmin" do
      context "for a developer document" do
        it "should redirect to the root url" do
          admin = create(:development_admin)
          login_as admin
          get url_for([:new, admin.permission_level.developer, :document])

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division document" do
        it "should redirect to the root url" do
          division_development = create(:division_development)
          admin = create(:development_admin, permission_level: division_development)

          login_as admin
          get url_for([:new, admin.permission_level.division, :document])

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a development document" do
        it "should return ok" do
          admin = create(:development_admin)

          login_as admin
          get url_for([:new, admin.permission_level, :document])

          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe "#create" do
    let(:params) { { document: { name: "" } } }

    context "as a DeveloperAdmin" do
      context "for a developer document" do
        it "should return ok" do
          admin = create(:developer_admin)
          login_as admin
          post url_for([admin.permission_level, :documents]), params: params

          expect(response.status).to eq(200)
        end
      end

      context "for a division document" do
        it "should return ok" do
          admin = create(:developer_admin)
          division = create(:division, developer: admin.permission_level)

          login_as admin
          post url_for([division, :documents]), params: params

          expect(response.status).to eq(200)
        end
      end

      context "for a development document" do
        it "should return ok" do
          admin = create(:developer_admin)
          development = create(:development, developer: admin.permission_level)

          login_as admin
          post url_for([development, :documents]), params: params

          expect(response.status).to eq(200)
        end
      end
    end

    context "as a DivisionAdmin" do
      context "for a developer document" do
        it "should redirect to the root url" do
          admin = create(:division_admin)
          login_as admin
          post url_for([admin.permission_level.developer, :documents]), params: params

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division document" do
        it "should return ok" do
          admin = create(:division_admin)

          login_as admin
          post url_for([admin.permission_level, :documents]), params: params

          expect(response.status).to eq(200)
        end
      end

      context "for a development document" do
        it "should return ok" do
          admin = create(:division_admin)
          division_development = create(:division_development, division: admin.permission_level)

          login_as admin
          post url_for([division_development, :documents]), params: params

          expect(response.status).to eq(200)
        end
      end
    end

    context "as a DevelopmentAdmin" do
      context "for a developer document" do
        it "should redirect to the root url" do
          admin = create(:development_admin)
          login_as admin
          post url_for([admin.permission_level.developer, :documents]), params: params

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division document" do
        it "should redirect to the root url" do
          division_development = create(:division_development)
          admin = create(:development_admin, permission_level: division_development)

          login_as admin
          post url_for([admin.permission_level.division, :documents]), params: params

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a development document" do
        it "should return ok" do
          admin = create(:development_admin)

          login_as admin
          post url_for([admin.permission_level, :documents]), params: params

          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe "#edit" do
    context "as a DeveloperAdmin" do
      context "for a developer document" do
        it "should return ok" do
          admin = create(:developer_admin)
          document = build(:document, documentable: admin.permission_level)
          document.save(validate: false)

          login_as admin
          get url_for([:edit, document])

          expect(response.status).to eq(200)
        end
      end

      context "for a division document" do
        it "should return ok" do
          admin = create(:developer_admin)
          division = create(:division, developer: admin.permission_level)
          document = build(:document, documentable: division)
          document.save(validate: false)

          login_as admin
          get url_for([:edit, document])

          expect(response.status).to eq(200)
        end
      end

      context "for a development document" do
        it "should return ok" do
          admin = create(:developer_admin)
          development = create(:development, developer: admin.permission_level)
          document = build(:document, documentable: development)
          document.save(validate: false)

          login_as admin
          get url_for([:edit, document])

          expect(response.status).to eq(200)
        end
      end
    end

    context "as a DivisionAdmin" do
      context "for a developer document" do
        it "should redirect to the root url" do
          admin = create(:division_admin)
          document = build(:document, documentable: admin.permission_level.developer)
          document.save(validate: false)

          login_as admin
          get url_for([:edit, document])

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division document" do
        it "should return ok" do
          admin = create(:division_admin)
          document = build(:document, documentable: admin.permission_level)
          document.save(validate: false)

          login_as admin
          get url_for([:edit, document])

          expect(response.status).to eq(200)
        end
      end

      context "for a development document" do
        it "should return ok" do
          admin = create(:division_admin)
          division_development = create(:division_development, division: admin.permission_level)
          document = build(:document, documentable: division_development)
          document.save(validate: false)

          login_as admin
          get url_for([:edit, document])

          expect(response.status).to eq(200)
        end
      end
    end

    context "as a DevelopmentAdmin" do
      context "for a developer document" do
        it "should redirect to the root url" do
          admin = create(:development_admin)
          document = build(:document, documentable: admin.permission_level.developer)
          document.save(validate: false)

          login_as admin
          get url_for([:edit, document])

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division document" do
        it "should redirect to the root url" do
          division_development = create(:division_development)
          admin = create(:development_admin, permission_level: division_development)
          document = build(:document, documentable: division_development.division)
          document.save(validate: false)

          login_as admin
          get url_for([:edit, document])

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a development document" do
        it "should return ok" do
          admin = create(:development_admin)
          document = build(:document, documentable: admin.permission_level)
          document.save(validate: false)

          login_as admin
          get url_for([:edit, document])

          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe "#update" do
    let(:params) { { document: { name: "" } } }

    context "as a DeveloperAdmin" do
      context "for a developer document" do
        it "should return ok" do
          admin = create(:developer_admin)
          document = build(:document, documentable: admin.permission_level)
          document.save(validate: false)

          login_as admin
          put url_for(document), params: params

          expect(response.redirect_url).not_to eq(root_url)
        end
      end

      context "for a division document" do
        it "should return ok" do
          admin = create(:developer_admin)
          division = create(:division, developer: admin.permission_level)
          document = build(:document, documentable: division)
          document.save(validate: false)

          login_as admin
          put url_for(document), params: params

          expect(response.redirect_url).not_to eq(root_url)
        end
      end

      context "for a development document" do
        it "should return ok" do
          admin = create(:developer_admin)
          development = create(:development, developer: admin.permission_level)
          document = build(:document, documentable: development)
          document.save(validate: false)

          login_as admin
          put url_for(document), params: params

          expect(response.redirect_url).not_to eq(root_url)
        end
      end
    end

    context "as a DivisionAdmin" do
      context "for a developer document" do
        it "should redirect to the root url" do
          admin = create(:division_admin)
          document = build(:document, documentable: admin.permission_level.developer)
          document.save(validate: false)

          login_as admin
          put url_for(document), params: params

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division document" do
        it "should return ok" do
          admin = create(:division_admin)
          document = build(:document, documentable: admin.permission_level)
          document.save(validate: false)

          login_as admin
          put url_for(document), params: params

          expect(response.redirect_url).not_to eq(root_url)
        end
      end

      context "for a development document" do
        it "should return ok" do
          admin = create(:division_admin)
          division_development = create(:division_development, division: admin.permission_level)
          document = build(:document, documentable: division_development)
          document.save(validate: false)

          login_as admin
          put url_for(document), params: params

          expect(response.redirect_url).not_to eq(root_url)
        end
      end
    end

    context "as a DevelopmentAdmin" do
      context "for a developer document" do
        it "should redirect to the root url" do
          admin = create(:development_admin)
          document = build(:document, documentable: admin.permission_level.developer)
          document.save(validate: false)

          login_as admin
          put url_for(document), params: params

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division document" do
        it "should redirect to the root url" do
          division_development = create(:division_development)
          admin = create(:development_admin, permission_level: division_development)
          document = build(:document, documentable: division_development.division)
          document.save(validate: false)

          login_as admin
          put url_for(document), params: params

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a development document" do
        it "should return ok" do
          admin = create(:development_admin)
          document = build(:document, documentable: admin.permission_level)
          document.save(validate: false)

          login_as admin
          put url_for(document), params: params

          expect(response.redirect_url).not_to eq(root_url)
        end
      end
    end
  end

  describe "#destroy" do
    context "as a DeveloperAdmin" do
      context "for a developer document" do
        it "should return ok" do
          admin = create(:developer_admin)
          document = build(:document, documentable: admin.permission_level)
          document.save(validate: false)

          login_as admin
          delete url_for(document)

          expect(response.redirect_url).not_to eq(root_url)
        end
      end

      context "for a division document" do
        it "should return ok" do
          admin = create(:developer_admin)
          division = create(:division, developer: admin.permission_level)
          document = build(:document, documentable: division)
          document.save(validate: false)

          login_as admin
          delete url_for(document)

          expect(response.redirect_url).not_to eq(root_url)
        end
      end

      context "for a development document" do
        it "should return ok" do
          admin = create(:developer_admin)
          development = create(:development, developer: admin.permission_level)
          document = build(:document, documentable: development)
          document.save(validate: false)

          login_as admin
          delete url_for(document)

          expect(response.redirect_url).not_to eq(root_url)
        end
      end
    end

    context "as a DivisionAdmin" do
      context "for a developer document" do
        it "should redirect to the root url" do
          admin = create(:division_admin)
          document = build(:document, documentable: admin.permission_level.developer)
          document.save(validate: false)

          login_as admin
          delete url_for(document)

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division document" do
        it "should return ok" do
          admin = create(:division_admin)
          document = build(:document, documentable: admin.permission_level)
          document.save(validate: false)

          login_as admin
          delete url_for(document)

          expect(response.redirect_url).not_to eq(root_url)
        end
      end

      context "for a development document" do
        it "should return ok" do
          admin = create(:division_admin)
          division_development = create(:division_development, division: admin.permission_level)
          document = build(:document, documentable: division_development)
          document.save(validate: false)

          login_as admin
          delete url_for(document)

          expect(response.redirect_url).not_to eq(root_url)
        end
      end
    end

    context "as a DevelopmentAdmin" do
      context "for a developer document" do
        it "should redirect to the root url" do
          admin = create(:development_admin)
          document = build(:document, documentable: admin.permission_level.developer)
          document.save(validate: false)

          login_as admin
          delete url_for(document)

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division document" do
        it "should redirect to the root url" do
          division_development = create(:division_development)
          admin = create(:development_admin, permission_level: division_development)
          document = build(:document, documentable: division_development.division)
          document.save(validate: false)

          login_as admin
          delete url_for(document)

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a development document" do
        it "should return ok" do
          admin = create(:development_admin)
          document = build(:document, documentable: admin.permission_level)
          document.save(validate: false)

          login_as admin
          delete url_for(document)

          expect(response.redirect_url).not_to eq(root_url)
        end
      end
    end
  end
end
