# frozen_string_literal: true
require "rails_helper"

RSpec.describe DevelopersController do
  describe "#index" do
    context "as a DeveloperAdmin" do
      it "should return ok" do
        login_as create(:developer_admin)
        get developers_path

        expect(response.status).to eq(200)
      end
    end

    context "as a DivisionAdmin" do
      it "should return ok" do
        login_as create(:division_admin)
        get developers_path

        expect(response.status).to eq(200)
      end
    end

    context "as a DevelopmentAdmin" do
      it "should return ok" do
        login_as create(:development_admin)
        get developers_path

        expect(response.status).to eq(200)
      end
    end
  end

  describe "#new" do
    context "as a DeveloperAdmin" do
      it "should redirect to the root url" do
        login_as create(:developer_admin)
        get new_developer_path

        expect(response.redirect_url).to eq(root_url)
      end
    end

    context "as a DivisionAdmin" do
      it "should redirect to the root url" do
        login_as create(:division_admin)
        get new_developer_path

        expect(response.redirect_url).to eq(root_url)
      end
    end

    context "as a DevelopmentAdmin" do
      it "should redirect to the root url" do
        login_as create(:development_admin)
        get new_developer_path

        expect(response.redirect_url).to eq(root_url)
      end
    end
  end

  describe "#create" do
    let(:params) { { params: { developer: { company_name: "" } } } }

    context "as a DeveloperAdmin" do
      it "should redirect to the root url" do
        login_as create(:developer_admin)
        post developers_path, params

        expect(response.redirect_url).to eq(root_url)
      end
    end

    context "as a DivisionAdmin" do
      it "should redirect to the root url" do
        login_as create(:division_admin)
        post developers_path, params

        expect(response.redirect_url).to eq(root_url)
      end
    end

    context "as a DevelopmentAdmin" do
      it "should redirect to the root url" do
        login_as create(:development_admin)
        post developers_path, params

        expect(response.redirect_url).to eq(root_url)
      end
    end
  end

  describe "#edit" do
    context "as a DeveloperAdmin" do
      it "should redirect to the root url" do
        admin = create(:developer_admin)
        login_as admin
        get edit_developer_path(admin.permission_level)

        expect(response.redirect_url).to eq(root_url)
      end
    end

    context "as a DivisionAdmin" do
      it "should redirect to the root url" do
        admin = create(:division_admin)
        login_as admin
        get edit_developer_path(admin.permission_level.developer)

        expect(response.redirect_url).to eq(root_url)
      end
    end

    context "as a DevelopmentAdmin" do
      it "should redirect to the root url" do
        admin = create(:development_admin)
        login_as admin

        get edit_developer_path(admin.permission_level.developer)

        expect(response.redirect_url).to eq(root_url)
      end
    end
  end

  describe "#update" do
    context "as a DeveloperAdmin" do
      it "should redirect to the root url" do
        admin = create(:developer_admin)
        login_as admin
        put developer_path(admin.permission_level)

        expect(response.redirect_url).to eq(root_url)
      end
    end

    context "as a DivisionAdmin" do
      it "should redirect to the root url" do
        admin = create(:division_admin)
        login_as admin
        put developer_path(admin.permission_level.developer)

        expect(response.redirect_url).to eq(root_url)
      end
    end

    context "as a DevelopmentAdmin" do
      it "should redirect to the root url" do
        admin = create(:development_admin)
        login_as admin

        put developer_path(admin.permission_level.developer)

        expect(response.redirect_url).to eq(root_url)
      end
    end
  end

  describe "#destroy" do
    context "as a DeveloperAdmin" do
      it "should redirect to the root url" do
        admin = create(:developer_admin)
        login_as admin
        delete developer_path(admin.permission_level)

        expect(response.redirect_url).to eq(root_url)
      end
    end

    context "as a DivisionAdmin" do
      it "should redirect to the root url" do
        admin = create(:division_admin)
        login_as admin
        delete developer_path(admin.permission_level.developer)

        expect(response.redirect_url).to eq(root_url)
      end
    end

    context "as a DevelopmentAdmin" do
      it "should redirect to the root url" do
        admin = create(:development_admin)
        login_as admin

        delete developer_path(admin.permission_level.developer)

        expect(response.redirect_url).to eq(root_url)
      end
    end
  end
end
