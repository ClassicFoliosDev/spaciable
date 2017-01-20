# frozen_string_literal: true
require "rails_helper"

RSpec.describe User do
  describe ".admin" do
    it "should not return homeowners" do
      create(:homeowner)
      cf_admin = create(:cf_admin)
      developer_admin = create(:developer_admin)
      division_admin = create(:division_admin)
      development_admin = create(:development_admin)
      admin_users = [cf_admin, developer_admin, division_admin, development_admin]

      collection = described_class.admin

      expect(collection.to_a).to match_array(admin_users)
    end
  end

  describe ".accessible_admin_roles" do
    context "for a CF Admin" do
      it "should return all admin roles" do
        user = described_class.new(role: :cf_admin)
        expected_roles = %w(cf_admin developer_admin division_admin development_admin)

        roles = described_class.accessible_admin_roles(user)
        expect(roles.keys).to match_array(expected_roles)
      end
    end

    context "for a Developer Admin" do
      it "should return all admin roles below CF Admin level" do
        user = described_class.new(role: :developer_admin)
        expected_roles = %w(developer_admin division_admin development_admin)

        roles = described_class.accessible_admin_roles(user)
        expect(roles.keys).to match_array(expected_roles)
      end
    end

    context "for a Division Admin" do
      it "should return all admin roles below Developer Admin level" do
        user = described_class.new(role: :division_admin)
        expected_roles = %w(division_admin development_admin)

        roles = described_class.accessible_admin_roles(user)
        expect(roles.keys).to match_array(expected_roles)
      end
    end

    context "for a Development Admin" do
      it "should return all admin roles below Division Admin level" do
        user = described_class.new(role: :development_admin)
        expected_roles = ["development_admin"]

        roles = described_class.accessible_admin_roles(user)
        expect(roles.keys).to match_array(expected_roles)
      end
    end
  end

  describe "#admin_roles" do
    it "does not include homeowner" do
      expect(described_class.admin_roles.keys).not_to include("homeowner")
    end
  end

  describe "#permission_level" do
    context "for CF Admin" do
      it "should be blank" do
        user = build(:cf_admin)

        expect(user.permission_level).to be_blank
      end
    end

    context "for Developer Admin" do
      it "should return the associated Developer" do
        developer = create(:developer)
        user = build(:developer_admin, permission_level: developer)

        expect(user.permission_level).to eq(developer)
      end

      it "should return a missing developer error when blank" do
        user = User.new(role: :developer_admin)

        user.validate

        error = I18n.t("activerecord.errors.models.user.attributes.developer_id.blank")
        expect(user.errors[:developer_id]).to include(error)
      end
    end

    context "for Division Admin" do
      it "should return the associated Division" do
        division = create(:division)
        user = build(:division_admin, permission_level: division)

        expect(user.permission_level).to eq(division)
      end

      it "should return a missing division error when blank" do
        user = User.new(role: :division_admin)

        user.validate

        error = I18n.t("activerecord.errors.models.user.attributes.division_id.blank")
        expect(user.errors[:division_id]).to include(error)
      end
    end

    context "for Development Admin" do
      it "should return the associated Development" do
        development = create(:development)
        user = build(:development_admin, permission_level: development)

        expect(user.permission_level).to eq(development)
      end

      it "should return a missing development error when blank" do
        user = User.new(role: :development_admin)

        user.validate

        error = I18n.t("activerecord.errors.models.user.attributes.development_id.blank")
        expect(user.errors[:development_id]).to include(error)
      end
    end
  end

  describe "#populate_permission_ids" do
    context "for a CF Admin" do
      it "should not populate the developer_id, division_id or development_id" do
        user = create(:cf_admin)
        user.populate_permission_ids

        expect(user.developer_id).to be_nil
        expect(user.division_id).to be_nil
        expect(user.development_id).to be_nil
      end
    end

    context "for a Homeowner" do
      it "should not populate the developer_id, division_id or development_id" do
        user = create(:homeowner)
        user.populate_permission_ids

        expect(user.developer_id).to be_nil
        expect(user.division_id).to be_nil
        expect(user.development_id).to be_nil
      end
    end

    context "for Development Admin" do
      it "should populate the developer_id" do
        developer = create(:developer)
        user = create(:developer_admin, permission_level: developer)

        user.populate_permission_ids
        expect(user.developer_id).to eq(developer.id)
        expect(user.division_id).to be_nil
        expect(user.development_id).to be_nil
      end
    end

    context "for Division Admin" do
      it "should populate the developer_id and division_id" do
        division = create(:division)
        user = create(:division_admin, permission_level: division)

        user.populate_permission_ids

        expect(user.developer_id).to eq(division.developer_id)
        expect(user.division_id).to eq(division.id)
        expect(user.development_id).to be_nil
      end
    end

    context "for Development Admin" do
      it "should populate the developer_id, and development_id" do
        development = create(:development)
        user = create(:development_admin, permission_level: development)

        user.populate_permission_ids

        expect(user.developer_id).to eq(development.developer_id)
        expect(user.division_id).to be_nil
        expect(user.development_id).to eq(development.id)
      end

      it "should populate the developer, division_id, and development_id" do
        development = create(:division_development)
        user = create(:development_admin, permission_level: development)

        user.populate_permission_ids

        expect(user.developer_id).to eq(development.division.developer_id)
        expect(user.division_id).to eq(development.division_id)
        expect(user.development_id).to eq(development.id)
      end
    end
  end

  describe "#create_without_password" do
    it "should create user without password supplied" do
      user = User.new

      user.create_without_password(email: "test@example.com", role: 0)

      expect(user).to be_valid
      expect(user).to be_persisted
    end

    it "should not affect the User.create method" do
      user = User.create(email: "test@example.com", role: 0)

      expect(user).not_to be_valid
      expect(user).not_to be_persisted
    end

    it "should not persist password if supplied" do
      user = User.new

      allow(user).to receive("password=").and_call_original
      allow(user).to receive("password_confirmation=").and_call_original

      user.create_without_password(
        email: "test@example.com",
        role: 0,
        password: "12345678",
        password_confirmation: "12345678"
      )

      expect(user).not_to have_received("password=").with("12345678")
      expect(user).not_to have_received("password_confirmation=").with("12345678")
      expect(user).to be_valid
      expect(user).to be_persisted
    end

    it "should not persist the password if already assigned to user object" do
      user = User.new(password: "12345678", password_confirmation: "12345678")

      user.create_without_password(
        email: "test@example.com",
        role: 0
      )

      expect(user.password).to be_nil
      expect(user.password_confirmation).to be_nil
      expect(user).to be_valid
      expect(user).to be_persisted
    end
  end

  describe "persisting roles" do
    context "as a CF Admin" do
      it "should set the permission_level to nil" do
        user = User.new(
          role: :cf_admin,
          developer_id: 1, division_id: 2, development_id: 3
        )

        user.validate

        expect(user.permission_level_id).to eq(nil)
        expect(user.permission_level_type).to eq(nil)
      end
    end

    context "as a Developer Admin" do
      it "should set the permission_level be the developer" do
        user = User.new(
          role: :developer_admin,
          developer_id: 1, division_id: 2, development_id: 3
        )

        user.validate

        expect(user.permission_level_id).to eq(1)
        expect(user.permission_level_type).to eq("Developer")
      end
    end

    context "as a Division Admin" do
      it "should set the permission_level be the division" do
        user = User.new(
          role: :division_admin,
          developer_id: 1, division_id: 2, development_id: 3
        )

        user.validate

        expect(user.permission_level_id).to eq(2)
        expect(user.permission_level_type).to eq("Division")
      end
    end

    context "as a Development Admin" do
      it "should set the permission_level be the development" do
        user = User.new(
          role: :development_admin,
          developer_id: 1, division_id: 2, development_id: 3
        )

        user.validate

        expect(user.permission_level_id).to eq(3)
        expect(user.permission_level_type).to eq("Development")
      end
    end
  end

  describe "#to_s" do
    context "without full name" do
      it "should return the email address" do
        email = "bob@bloggs.com"
        user = User.new(email: email)

        expect(user.to_s).to eq(email)
      end
    end

    context "with full name" do
      it "should return the full name" do
        user = User.new(first_name: "Bob", last_name: "Bloggs", email: "bob@bloggs.com")

        expect(user.to_s).to eq("Bob Bloggs")
      end
    end
  end
end
