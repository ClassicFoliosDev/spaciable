# frozen_string_literal: true

require "rails_helper"

RSpec.describe DivisionsController do
  describe "#new" do
    context "as a DeveloperAdmin" do
      it "should redirect to the root url" do
        login_as create(:developer_admin)
        get new_division_path

        expect(response.redirect_url).to eq(root_url)
      end
    end

    context "as a DivisionAdmin" do
      it "should redirect to the root url" do
        login_as create(:division_admin)
        get new_division_path

        expect(response.redirect_url).to eq(root_url)
      end
    end

    context "as a DevelopmentAdmin" do
      it "should redirect to the root url" do
        login_as create(:development_admin)
        get new_division_path

        expect(response.redirect_url).to eq(root_url)
      end
    end

    context "as a SiteAdmin" do
      it "should redirect to the root url" do
        login_as create(:site_admin)
        get new_division_path

        expect(response.redirect_url).to eq(root_url)
      end
    end
  end

  describe "#create" do
    let(:params) { { division: { division_name: "" } } }

    context "as a DeveloperAdmin" do
      it "should redirect to the root url" do
        login_as create(:developer_admin)
        post divisions_path, params: params

        expect(response.redirect_url).to eq(root_url)
      end
    end

    context "as a DivisionAdmin" do
      it "should redirect to the root url" do
        login_as create(:division_admin)
        post divisions_path, params: params

        expect(response.redirect_url).to eq(root_url)
      end
    end

    context "as a DevelopmentAdmin" do
      it "should redirect to the root url" do
        login_as create(:development_admin)
        post divisions_path, params: params

        expect(response.redirect_url).to eq(root_url)
      end
    end

    context "as a SiteAdmin" do
      it "should redirect to the root url" do
        login_as create(:site_admin)
        post divisions_path, params: params

        expect(response.redirect_url).to eq(root_url)
      end
    end
  end

  describe "#edit" do
    context "as a DeveloperAdmin" do
      it "should redirect to the root url" do
        admin = create(:developer_admin)
        division = create(:division, developer: admin.permission_level)

        login_as admin
        get edit_division_path(division)

        expect(response.redirect_url).to eq(root_url)
      end
    end

    context "as a DivisionAdmin" do
      it "should redirect to the root url" do
        admin = create(:division_admin)
        login_as admin
        get edit_division_path(admin.permission_level)

        expect(response.redirect_url).to eq(root_url)
      end
    end

    context "as a DevelopmentAdmin" do
      it "should redirect to the root url" do
        division_development = create(:division_development)
        admin = create(:development_admin, permission_level: division_development)
        login_as admin

        get edit_division_path(admin.permission_level.division)

        expect(response.redirect_url).to eq(root_url)
      end
    end

    context "as a SiteAdmin" do
      it "should redirect to the root url" do
        division_development = create(:division_development)
        admin = create(:site_admin, permission_level: division_development)
        login_as admin

        get edit_division_path(admin.permission_level.division)

        expect(response.redirect_url).to eq(root_url)
      end
    end
  end

  describe "#update" do
    context "as a DeveloperAdmin" do
      it "should redirect to the root url" do
        admin = create(:developer_admin)
        division = create(:division, developer: admin.permission_level)
        login_as admin
        put division_path(division)

        expect(response.redirect_url).to eq(root_url)
      end
    end

    context "as a DivisionAdmin" do
      it "should redirect to the root url" do
        admin = create(:division_admin)
        login_as admin
        put division_path(admin.permission_level)

        expect(response.redirect_url).to eq(root_url)
      end
    end

    context "as a DevelopmentAdmin" do
      it "should redirect to the root url" do
        division_development = create(:division_development)
        admin = create(:development_admin, permission_level: division_development)
        login_as admin

        put division_path(admin.permission_level.division)

        expect(response.redirect_url).to eq(root_url)
      end
    end

    context "as a SiteAdmin" do
      it "should redirect to the root url" do
        division_development = create(:division_development)
        admin = create(:site_admin, permission_level: division_development)
        login_as admin

        put division_path(admin.permission_level.division)

        expect(response.redirect_url).to eq(root_url)
      end
    end
  end

  describe "#destroy" do
    context "as a DeveloperAdmin" do
      it "should redirect to the root url" do
        admin = create(:developer_admin)
        division = create(:division, developer: admin.permission_level)

        login_as admin
        delete division_path(division)

        expect(response.redirect_url).to eq(root_url)
      end
    end

    context "as a DivisionAdmin" do
      it "should redirect to the root url" do
        admin = create(:division_admin)
        login_as admin
        delete division_path(admin.permission_level)

        expect(response.redirect_url).to eq(root_url)
      end
    end

    context "as a DevelopmentAdmin" do
      it "should redirect to the root url" do
        division_development = create(:division_development)
        admin = create(:development_admin, permission_level: division_development)
        login_as admin

        delete division_path(admin.permission_level.division)

        expect(response.redirect_url).to eq(root_url)
      end
    end

    context "as a SiteAdmin" do
      it "should redirect to the root url" do
        division_development = create(:division_development)
        admin = create(:site_admin, permission_level: division_development)
        login_as admin

        delete division_path(admin.permission_level.division)

        expect(response.redirect_url).to eq(root_url)
      end
    end
  end
end
