# frozen_string_literal: true

require "rails_helper"

RSpec.describe FaqsController do
  describe "#index" do
    context "as a DeveloperAdmin" do
      context "for a developer faq" do
        it "should return ok" do
          admin = create(:developer_admin)
          create(:faq_type)
          login_as admin
          get url_for([admin.permission_level, :faqs, active_tab: 1])

          expect(response.status).to eq(200)
        end
      end

      context "for a division faq" do
        it "should return ok" do
          admin = create(:developer_admin)
          create(:faq_type)
          division = create(:division, developer: admin.permission_level)

          login_as admin
          get url_for([division, :faqs, active_tab: 1])

          expect(response.status).to eq(200)
        end
      end

      context "for a development faq" do
        it "should return ok" do
          admin = create(:developer_admin)
          create(:faq_type)
          development = create(:development, developer: admin.permission_level)

          login_as admin
          get url_for([development, :faqs, active_tab: 1])

          expect(response.status).to eq(200)
        end
      end
    end

    context "as a DivisionAdmin" do
      context "for a developer faq" do
        it "should redirect to the root url" do
          admin = create(:division_admin)
          create(:faq_type)
          login_as admin
          get url_for([admin.permission_level.developer, :faqs, active_tab: 1])

          expect(response.status).to eq(200)
        end
      end

      context "for a division faq" do
        it "should return ok" do
          admin = create(:division_admin)
          create(:faq_type)

          login_as admin
          get url_for([admin.permission_level, :faqs, active_tab: 1])

          expect(response.status).to eq(200)
        end
      end

      context "for a development faq" do
        it "should return ok" do
          admin = create(:division_admin)
          create(:faq_type)
          division_development = create(:division_development, division: admin.permission_level)

          login_as admin
          get url_for([division_development, :faqs, active_tab: 1])

          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe "#new" do
    context "as a DeveloperAdmin" do
      context "for a developer faq" do
        it "should return ok" do
          create(:country)
          admin = create(:developer_admin)
          create(:faq_type)
          login_as admin
          get url_for([:new, admin.permission_level, :faq, active_tab: 1])

          expect(response.status).to eq(200)
        end
      end

      context "for a division faq" do
        it "should return ok" do
          create(:country)
          admin = create(:developer_admin)
          create(:faq_type)
          division = create(:division, developer: admin.permission_level)

          login_as admin
          get url_for([:new, division, :faq, active_tab: 1])

          expect(response.status).to eq(200)
        end
      end

      context "for a development faq" do
        it "should return ok" do
          create(:country)
          admin = create(:developer_admin)
          create(:faq_type)
          development = create(:development, developer: admin.permission_level)

          login_as admin
          get url_for([:new, development, :faq, active_tab: 1])

          expect(response.status).to eq(200)
        end
      end
    end

    context "as a DivisionAdmin" do
      context "for a developer faq" do
        it "should redirect to the root url" do
          create(:country)
          admin = create(:division_admin)
          create(:faq_type)
          login_as admin
          get url_for([:new, admin.permission_level.developer, :faq, active_tab: 1])

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division faq" do
        it "should return ok" do
          create(:country)
          admin = create(:division_admin)
          create(:faq_type)

          login_as admin
          get url_for([:new, admin.permission_level, :faq, active_tab: 1])

          expect(response.status).to eq(200)
        end
      end

      context "for a development faq" do
        it "should return ok" do
          create(:country)
          admin = create(:division_admin)
          create(:faq_type)
          division_development = create(:division_development, division: admin.permission_level)

          login_as admin
          get url_for([:new, division_development, :faq,  active_tab: 1])

          expect(response.status).to eq(200)
        end
      end
    end

    context "as a DevelopmentAdmin" do
      context "for a developer faq" do
        it "should redirect to the root url" do
          create(:country)
          admin = create(:development_admin)
          create(:faq_type)
          login_as admin
          get url_for([:new, admin.permission_level.developer, :faq, active_tab: 1])

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division faq" do
        it "should redirect to the root url" do
          create(:country)
          division_development = create(:division_development)
          create(:faq_type)
          admin = create(:development_admin, permission_level: division_development)

          login_as admin
          get url_for([:new, admin.permission_level.division, :faq, active_tab: 1])

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a development faq" do
        it "should return ok" do
          create(:country)
          admin = create(:development_admin)
          create(:faq_type)

          login_as admin
          get url_for([:new, admin.permission_level, :faq, active_tab: 1])

          expect(response.status).to eq(200)
        end
      end
    end

    context "as a SiteAdmin" do
      context "for a developer faq" do
        it "should redirect to the root url" do
          create(:country)
          admin = create(:site_admin)
          login_as admin
          get url_for([:new, admin.permission_level.developer, :faq])

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division faq" do
        it "should redirect to the root url" do
          division_development = create(:division_development)
          admin = create(:site_admin, permission_level: division_development)

          login_as admin
          get url_for([:new, admin.permission_level.division, :faq])

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a development faq" do
        it "should redirect to the root url" do
          admin = create(:site_admin)

          login_as admin
          get url_for([:new, admin.permission_level, :faq])

          expect(response.redirect_url).to eq(root_url)
        end
      end
    end
  end

  describe "#create" do
    let(:params) { { faq: { name: "", faq_type_id: 1, faq_category_id: 1 } } }

    context "as a DeveloperAdmin" do
      context "for a developer faq" do
        it "should return ok" do
          create(:country)
          admin = create(:developer_admin)
          create(:faq_type)
          create(:faq_category)
          login_as admin
          post url_for([admin.permission_level, :faqs]), params: params

          expect(response.status).to eq(200)
        end
      end

      context "for a division faq" do
        it "should return ok" do
          create(:country)
          admin = create(:developer_admin)
          create(:faq_type)
          create(:faq_category)
          division = create(:division, developer: admin.permission_level)

          login_as admin
          post url_for([division, :faqs]), params: params

          expect(response.status).to eq(200)
        end
      end

      context "for a development faq" do
        it "should return ok" do
          create(:country)
          admin = create(:developer_admin)
          create(:faq_type)
          create(:faq_category)
          development = create(:development, developer: admin.permission_level)

          login_as admin
          post url_for([development, :faqs]), params: params

          expect(response.status).to eq(200)
        end
      end
    end

    context "as a DivisionAdmin" do
      context "for a developer faq" do
        it "should redirect to the root url" do
          create(:country)
          admin = create(:division_admin)
          login_as admin
          post url_for([admin.permission_level.developer, :faqs]), params: params

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division faq" do
        it "should return ok" do
          create(:country)
          admin = create(:division_admin)
          create(:faq_type)
          create(:faq_category)

          login_as admin
          post url_for([admin.permission_level, :faqs]), params: params

          expect(response.status).to eq(200)
        end
      end

      context "for a development faq" do
        it "should return ok" do
          create(:country)
          admin = create(:division_admin)
          create(:faq_type)
          create(:faq_category)
          division_development = create(:division_development, division: admin.permission_level)

          login_as admin
          post url_for([division_development, :faqs]), params: params

          expect(response.status).to eq(200)
        end
      end
    end

    context "as a DevelopmentAdmin" do
      context "for a developer faq" do
        it "should redirect to the root url" do
          create(:country)
          admin = create(:development_admin)
          login_as admin
          post url_for([admin.permission_level.developer, :faqs]), params: params

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division faq" do
        it "should redirect to the root url" do
          create(:country)
          division_development = create(:division_development)
          admin = create(:development_admin, permission_level: division_development)

          login_as admin
          post url_for([admin.permission_level.division, :faqs]), params: params

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a development faq" do
        it "should return ok" do
          create(:country)
          admin = create(:development_admin)
          create(:faq_type)
          create(:faq_category)

          login_as admin
          post url_for([admin.permission_level, :faqs]), params: params

          expect(response.status).to eq(200)
        end
      end
    end

    context "as a SiteAdmin" do
      context "for a developer faq" do
        it "should redirect to the root url" do
          create(:country)
          admin = create(:site_admin)
          login_as admin
          post url_for([admin.permission_level.developer, :faqs]), params: params

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division faq" do
        it "should redirect to the root url" do
          create(:country)
          division_development = create(:division_development)
          admin = create(:site_admin, permission_level: division_development)

          login_as admin
          post url_for([admin.permission_level.division, :faqs]), params: params

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a development faq" do
        it "should redirect to the root url" do
          create(:country)
          admin = create(:site_admin)

          login_as admin
          post url_for([admin.permission_level, :faqs]), params: params

          expect(response.redirect_url).to eq(root_url)
        end
      end
    end
  end

  describe "#edit" do
    context "as a DeveloperAdmin" do
      context "for a developer faq" do
        it "should return ok" do
          create(:country)
          admin = create(:developer_admin)
          faq = create(:faq, faqable: admin.permission_level)

          login_as admin
          get url_for([:edit, faq])

          expect(response.status).to eq(200)
        end
      end

      context "for a division faq" do
        it "should return ok" do
          create(:country)
          admin = create(:developer_admin)
          division = create(:division, developer: admin.permission_level)
          faq = create(:faq, faqable: division)

          login_as admin
          get url_for([:edit, faq])

          expect(response.status).to eq(200)
        end
      end

      context "for a development faq" do
        it "should return ok" do
          create(:country)
          admin = create(:developer_admin)
          development = create(:development, developer: admin.permission_level)
          faq = create(:faq, faqable: development)

          login_as admin
          get url_for([:edit, faq])

          expect(response.status).to eq(200)
        end
      end
    end

    context "as a DivisionAdmin" do
      context "for a developer faq" do
        it "should redirect to the root url" do
          create(:country)
          admin = create(:division_admin)
          faq = create(:faq, faqable: admin.permission_level.developer)

          login_as admin
          get url_for([:edit, faq])

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division faq" do
        it "should return ok" do
          create(:country)
          admin = create(:division_admin)
          faq = create(:faq, faqable: admin.permission_level)

          login_as admin
          get url_for([:edit, faq])

          expect(response.status).to eq(200)
        end
      end

      context "for a development faq" do
        it "should return ok" do
          create(:country)
          admin = create(:division_admin)
          division_development = create(:division_development, division: admin.permission_level)
          faq = create(:faq, faqable: division_development)

          login_as admin
          get url_for([:edit, faq])

          expect(response.status).to eq(200)
        end
      end
    end

    context "as a DevelopmentAdmin" do
      context "for a developer faq" do
        it "should redirect to the root url" do
          create(:country)
          admin = create(:development_admin)
          faq = create(:faq, faqable: admin.permission_level.developer)

          login_as admin
          get url_for([:edit, faq])

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division faq" do
        it "should redirect to the root url" do
          create(:country)
          division_development = create(:division_development)
          admin = create(:development_admin, permission_level: division_development)
          faq = create(:faq, faqable: division_development.division)

          login_as admin
          get url_for([:edit, faq])

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a development faq" do
        it "should return ok" do
          create(:country)
          admin = create(:development_admin)
          faq = create(:faq, faqable: admin.permission_level)

          login_as admin
          get url_for([:edit, faq])

          expect(response.status).to eq(200)
        end
      end
    end

    context "as a SiteAdmin" do
      context "for a developer faq" do
        it "should redirect to the root url" do
          create(:country)
          admin = create(:site_admin)
          faq = create(:faq, faqable: admin.permission_level.developer)

          login_as admin
          get url_for([:edit, faq])

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division faq" do
        it "should redirect to the root url" do
          create(:country)
          division_development = create(:division_development)
          admin = create(:site_admin, permission_level: division_development)
          faq = create(:faq, faqable: division_development.division)

          login_as admin
          get url_for([:edit, faq])

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a development faq" do
        it "should redirect to the root url" do
          create(:country)
          admin = create(:site_admin)
          faq = create(:faq, faqable: admin.permission_level)

          login_as admin
          get url_for([:edit, faq])

          expect(response.redirect_url).to eq(root_url)
        end
      end
    end
  end

  describe "#update" do
    let(:params) { { faq: { name: "" } } }

    context "as a DeveloperAdmin" do
      context "for a developer faq" do
        it "should return ok" do
          create(:country)
          admin = create(:developer_admin)
          faq = create(:faq, faqable: admin.permission_level)

          login_as admin
          put url_for(faq), params: params

          expect(response.redirect_url).not_to eq(root_url)
        end
      end

      context "for a division faq" do
        it "should return ok" do
          create(:country)
          admin = create(:developer_admin)
          division = create(:division, developer: admin.permission_level)
          faq = create(:faq, faqable: division)

          login_as admin
          put url_for(faq), params: params

          expect(response.redirect_url).not_to eq(root_url)
        end
      end

      context "for a development faq" do
        it "should return ok" do
          admin = create(:developer_admin)
          development = create(:development, developer: admin.permission_level)
          faq = create(:faq, faqable: development)

          login_as admin
          put url_for(faq), params: params

          expect(response.redirect_url).not_to eq(root_url)
        end
      end
    end

    context "as a DivisionAdmin" do
      context "for a developer faq" do
        it "should redirect to the root url" do
          admin = create(:division_admin)
          faq = create(:faq, faqable: admin.permission_level.developer)

          login_as admin
          put url_for(faq), params: params

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division faq" do
        it "should return ok" do
          admin = create(:division_admin)
          faq = create(:faq, faqable: admin.permission_level)

          login_as admin
          put url_for(faq), params: params

          expect(response.redirect_url).not_to eq(root_url)
        end
      end

      context "for a development faq" do
        it "should return ok" do
          admin = create(:division_admin)
          division_development = create(:division_development, division: admin.permission_level)
          faq = create(:faq, faqable: division_development)

          login_as admin
          put url_for(faq), params: params

          expect(response.redirect_url).not_to eq(root_url)
        end
      end
    end

    context "as a DevelopmentAdmin" do
      context "for a developer faq" do
        it "should redirect to the root url" do
          admin = create(:development_admin)
          faq = create(:faq, faqable: admin.permission_level.developer)

          login_as admin
          put url_for(faq), params: params

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division faq" do
        it "should redirect to the root url" do
          division_development = create(:division_development)
          admin = create(:development_admin, permission_level: division_development)
          faq = create(:faq, faqable: division_development.division)

          login_as admin
          put url_for(faq), params: params

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a development faq" do
        it "should return ok" do
          admin = create(:development_admin)
          faq = create(:faq, faqable: admin.permission_level)

          login_as admin
          put url_for(faq), params: params

          expect(response.redirect_url).not_to eq(root_url)
        end
      end
    end

    context "as a SiteAdmin" do
      context "for a developer faq" do
        it "should redirect to the root url" do
          admin = create(:site_admin)
          faq = create(:faq, faqable: admin.permission_level.developer)

          login_as admin
          put url_for(faq), params: params

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division faq" do
        it "should redirect to the root url" do
          division_development = create(:division_development)
          admin = create(:site_admin, permission_level: division_development)
          faq = create(:faq, faqable: division_development.division)

          login_as admin
          put url_for(faq), params: params

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a development faq" do
        it "should redirect to the root url" do
          admin = create(:site_admin)
          faq = create(:faq, faqable: admin.permission_level)

          login_as admin
          put url_for(faq), params: params

          expect(response.redirect_url).to eq(root_url)
        end
      end
    end
  end

  describe "#destroy" do
    context "as a DeveloperAdmin" do
      context "for a developer faq" do
        it "should return ok" do
          admin = create(:developer_admin)
          faq = create(:faq, faqable: admin.permission_level)

          login_as admin
          delete url_for(faq)

          expect(response.redirect_url).not_to eq(root_url)
        end
      end

      context "for a division faq" do
        it "should return ok" do
          admin = create(:developer_admin)
          division = create(:division, developer: admin.permission_level)
          faq = create(:faq, faqable: division)

          login_as admin
          delete url_for(faq)

          expect(response.redirect_url).not_to eq(root_url)
        end
      end

      context "for a development faq" do
        it "should return ok" do
          admin = create(:developer_admin)
          development = create(:development, developer: admin.permission_level)
          faq = create(:faq, faqable: development)

          login_as admin
          delete url_for(faq)

          expect(response.redirect_url).not_to eq(root_url)
        end
      end
    end

    context "as a DivisionAdmin" do
      context "for a developer faq" do
        it "should redirect to the root url" do
          admin = create(:division_admin)
          faq = create(:faq, faqable: admin.permission_level.developer)

          login_as admin
          delete url_for(faq)

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division faq" do
        it "should return ok" do
          admin = create(:division_admin)
          faq = create(:faq, faqable: admin.permission_level)

          login_as admin
          delete url_for(faq)

          expect(response.redirect_url).not_to eq(root_url)
        end
      end

      context "for a development faq" do
        it "should return ok" do
          admin = create(:division_admin)
          division_development = create(:division_development, division: admin.permission_level)
          faq = create(:faq, faqable: division_development)

          login_as admin
          delete url_for(faq)

          expect(response.redirect_url).not_to eq(root_url)
        end
      end
    end

    context "as a DevelopmentAdmin" do
      context "for a developer faq" do
        it "should redirect to the root url" do
          admin = create(:development_admin)
          faq = create(:faq, faqable: admin.permission_level.developer)

          login_as admin
          delete url_for(faq)

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division faq" do
        it "should redirect to the root url" do
          division_development = create(:division_development)
          admin = create(:development_admin, permission_level: division_development)
          faq = create(:faq, faqable: division_development.division)

          login_as admin
          delete url_for(faq)

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a development faq" do
        it "should return ok" do
          admin = create(:development_admin)
          faq = create(:faq, faqable: admin.permission_level)

          login_as admin
          delete url_for(faq)

          expect(response.redirect_url).not_to eq(root_url)
        end
      end
    end

    context "as a SiteAdmin" do
      context "for a developer faq" do
        it "should redirect to the root url" do
          admin = create(:site_admin)
          faq = create(:faq, faqable: admin.permission_level.developer)

          login_as admin
          delete url_for(faq)

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a division faq" do
        it "should redirect to the root url" do
          division_development = create(:division_development)
          admin = create(:site_admin, permission_level: division_development)
          faq = create(:faq, faqable: division_development.division)

          login_as admin
          delete url_for(faq)

          expect(response.redirect_url).to eq(root_url)
        end
      end

      context "for a development faq" do
        it "should redirect to the root url" do
          admin = create(:site_admin)
          faq = create(:faq, faqable: admin.permission_level)

          login_as admin
          delete url_for(faq)

          expect(response.redirect_url).to eq(root_url)
        end
      end
    end
  end
end
