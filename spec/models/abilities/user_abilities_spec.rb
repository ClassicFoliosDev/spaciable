# frozen_string_literal: true

require "rails_helper"
require "cancan/matchers"

RSpec.describe "User Abilities" do
  subject { Ability.new(current_user) }

  context "As a CF Admin" do
    let(:current_user) { create(:cf_admin) }

    it { expect(subject).to be_able_to :manage, User.new }
  end

  context "As a Developer Admin" do
    let(:current_user) { create(:developer_admin) }

    it "can crud developer admin users" do
      user = User.new(role: :developer_admin, permission_level: current_user.permission_level)

      expect(subject).to be_able_to(:create, User.new(role: :developer_admin))
      expect(subject).to be_able_to(:read, user)
      expect(subject).to be_able_to(:update, user)
      expect(subject).to be_able_to(:destroy, user)
    end

    it "can crud division admins" do
      division = create(:division, developer: current_user.permission_level)
      user = User.new(role: :division_admin, permission_level: division)

      expect(subject).to be_able_to(:create, User.new(role: :division_admin))
      expect(subject).to be_able_to(:read, user)
      expect(subject).to be_able_to(:update, user)
      expect(subject).to be_able_to(:destroy, user)
    end

    it "can crud development admins" do
      development = create(:development, developer: current_user.permission_level)
      user = User.new(role: :development_admin, permission_level: development)

      expect(subject).to be_able_to(:create, User.new(role: :development_admin))
      expect(subject).to be_able_to(:read, user)
      expect(subject).to be_able_to(:update, user)
      expect(subject).to be_able_to(:destroy, user)
    end

    it "can crud division development admins" do
      division = create(:division, developer: current_user.permission_level)
      development = create(:division_development, division: division)
      user = User.new(role: :development_admin, permission_level: development)

      expect(subject).to be_able_to(:create, User.new(role: :development_admin))
      expect(subject).to be_able_to(:read, user)
      expect(subject).to be_able_to(:update, user)
      expect(subject).to be_able_to(:destroy, user)
    end

    it "can crud site admins" do
      development = create(:development, developer: current_user.permission_level)
      user = User.new(role: :site_admin, permission_level: development)

      expect(subject).to be_able_to(:create, User.new(role: :site_admin))
      expect(subject).to be_able_to(:read, user)
      expect(subject).to be_able_to(:update, user)
      expect(subject).to be_able_to(:destroy, user)
    end

    it "cannot crud CF Admin users" do
      expect(subject).not_to be_able_to(:crud, User.new(role: :cf_admin))
    end
    it "cannot crud developer admins from other developers" do
      user = User.new(role: :developer_admin, permission_level: create(:developer))

      expect(subject).not_to be_able_to(:crud, user)
    end
  end

  context "As a Division Admin" do
    let(:current_user) { create(:division_admin) }

    it "can crud division admin users" do
      user = User.new(role: :division_admin, permission_level: current_user.permission_level)

      expect(subject).to be_able_to(:create, User.new(role: :division_admin))
      expect(subject).to be_able_to(:read, user)
      expect(subject).to be_able_to(:update, user)
      expect(subject).to be_able_to(:destroy, user)
    end

    it "cannot crud CF Admin users" do
      user = User.new(role: :cf_admin)

      expect(subject).not_to be_able_to(:read, user)
      expect(subject).not_to be_able_to(:update, user)
      expect(subject).not_to be_able_to(:destroy, user)
    end
    it "cannot crud Developer Admin users" do
      user = User.new(role: :developer_admin)

      expect(subject).not_to be_able_to(:read, user)
      expect(subject).not_to be_able_to(:update, user)
      expect(subject).not_to be_able_to(:destroy, user)
    end

    it "cannot crud division admins from other divisions" do
      user = User.new(role: :division_admin, permission_level: create(:division))

      expect(subject).not_to be_able_to(:read, user)
      expect(subject).not_to be_able_to(:update, user)
      expect(subject).not_to be_able_to(:destroy, user)
    end

    it "cannot crud (developer) development admins" do
      developer = current_user.permission_level.developer
      development = create(:development, developer: developer)
      user = User.new(role: :development_admin, permission_level: development)

      expect(subject).not_to be_able_to(:read, user)
      expect(subject).not_to be_able_to(:update, user)
      expect(subject).not_to be_able_to(:destroy, user)
    end

    it "can crud division development admins" do
      division = current_user.permission_level
      development = create(:division_development, division: division)
      user = User.new(role: :development_admin, permission_level: development)

      expect(subject).to be_able_to(:create, User.new(role: :development_admin))
      expect(subject).to be_able_to(:read, user)
      expect(subject).to be_able_to(:update, user)
      expect(subject).to be_able_to(:destroy, user)
    end

    it "can crud site admins" do
      development = create(:development, division: current_user.permission_level)
      user = User.new(role: :site_admin, permission_level: development)

      expect(subject).to be_able_to(:create, User.new(role: :site_admin))
      expect(subject).to be_able_to(:read, user)
      expect(subject).to be_able_to(:update, user)
      expect(subject).to be_able_to(:destroy, user)
    end
  end

  context "As a Development Admin" do
    let(:current_user) { create(:development_admin) }

    it "cannot crud CF Admin users" do
      expect(subject).not_to be_able_to(:crud, User.new(role: :cf_admin))
    end
    it "cannot crud Developer Admin users" do
      expect(subject).not_to be_able_to(:crud, User.new(role: :developer_admin))
    end

    it "cannot crud division admins" do
      expect(subject).not_to be_able_to(:crud, User.new(role: :division_admin))
    end

    it "can crud development admins" do
      development = current_user.permission_level
      user = User.new(role: :development_admin, permission_level: development)

      expect(subject).to be_able_to(:create, User.new(role: :development_admin))
      expect(subject).to be_able_to(:read, user)
      expect(subject).to be_able_to(:update, user)
      expect(subject).to be_able_to(:destroy, user)
    end

    it "can crud site admins" do
      development = current_user.permission_level
      user = User.new(role: :site_admin, permission_level: development)

      expect(subject).to be_able_to(:create, User.new(role: :site_admin))
      expect(subject).to be_able_to(:read, user)
      expect(subject).to be_able_to(:update, user)
      expect(subject).to be_able_to(:destroy, user)
    end
  end

  context "As a (Division) Development Admin" do
    let(:current_user) do
      development = create(:division_development)
      create(:development_admin, permission_level: development)
    end

    it "can read developer" do
      developer = current_user.permission_level.division.developer

      expect(subject).to be_able_to(:read, developer)
    end

    it "cannot crud CF Admin users" do
      expect(subject).not_to be_able_to(:crud, User.new(role: :cf_admin))
    end

    it "cannot crud Developer Admin users" do
      expect(subject).not_to be_able_to(:crud, User.new(role: :developer_admin))
    end

    it "cannot crud division admins" do
      expect(subject).not_to be_able_to(:crud, User.new(role: :division_admin))
    end

    it "cannot crud (developer) development admins" do
      division_development = current_user.permission_level
      developer = division_development.division.developer
      development = create(:development, developer: developer)
      user = User.new(role: :development_admin, permission_level: development)

      expect(subject).not_to be_able_to(:read, user)
      expect(subject).not_to be_able_to(:update, user)
      expect(subject).not_to be_able_to(:destroy, user)
    end

    it "can crud (division) development admins" do
      division_development = current_user.permission_level
      user = User.new(role: :development_admin, permission_level: division_development)

      expect(subject).to be_able_to(:create, User.new(role: :development_admin))
      expect(subject).to be_able_to(:read, user)
      expect(subject).to be_able_to(:update, user)
      expect(subject).to be_able_to(:destroy, user)
    end
  end

  context "As a Site Admin" do
    let(:current_user) { create(:site_admin) }

    it "cannot crud CF Admin users" do
      expect(subject).not_to be_able_to(:crud, User.new(role: :cf_admin))
    end
    it "cannot crud Developer Admin users" do
      expect(subject).not_to be_able_to(:crud, User.new(role: :developer_admin))
    end

    it "cannot crud division admins" do
      expect(subject).not_to be_able_to(:crud, User.new(role: :division_admin))
    end

    it "cannot crud development admins" do
      expect(subject).not_to be_able_to(:crud, User.new(role: :development_admin))
    end

    it "can crud site admins" do
      development = current_user.permission_level
      user = User.new(role: :site_admin, permission_level: development)
      expect(subject).to be_able_to(:read, user)
      expect(subject).to be_able_to(:update, user)
      expect(subject).to be_able_to(:destroy, user)

      expect(subject).not_to be_able_to(:crud, User.new(role: :site_admin))
    end
  end
end
