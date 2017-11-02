# frozen_string_literal: true

require "rails_helper"

RSpec.describe DivisionsController do
  describe "#index" do
    context "as a DeveloperAdmin" do
      it "should redirect to the root url" do
        admin = create(:developer_admin)
        login_as admin
        get url_for([admin.permission_level, :divisions])

        expect(response.status).to eq(200)
      end
    end

    context "as a DivisionAdmin" do
      it "should redirect to the root url" do
        admin = create(:division_admin)
        login_as admin
        get url_for([admin.permission_level.developer, :divisions])

        expect(response.status).to eq(200)
      end
    end

    context "as a DevelopmentAdmin" do
      it "should redirect to the root url" do
        admin = create(:development_admin)
        login_as admin
        get url_for([admin.permission_level.developer, :developments])

        expect(response.status).to eq(200)
      end
    end
  end

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
  end

  describe "#create" do
    let(:params) { { params: { division: { division_name: "" } } } }

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
  end
end
