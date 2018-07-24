# frozen_string_literal: true

RSpec.shared_examples "it has cascading polymorphic abilities" do |polymorphic_class|
  let(:model_name) { polymorphic_class.model_name }
  let(:belongs_to_association) { model_name.element + "able" }
  let(:safe_actions) { [:read] }
  let(:unsafe_actions) { %i[create update destroy] }
  let(:all_actions) { safe_actions.concat(unsafe_actions) }

  context "as a Developer Admin" do
    let(:current_user) { create(:developer_admin) }
    let(:model_instance) { polymorphic_class.new }

    specify "I can CRUD a model when associated with my developer" do
      developer = current_user.permission_level
      model_instance.send("#{belongs_to_association}=", developer)

      all_actions.each do |action|
        expect(subject).to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with another developer" do
      other_developer = create(:developer)
      model_instance.send("#{belongs_to_association}=", other_developer)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I can CRUD a model when associated with a division that is under my developer" do
      developer = current_user.permission_level
      division = create(:division, developer: developer)
      model_instance.send("#{belongs_to_association}=", division)

      all_actions.each do |action|
        expect(subject).to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with another developers division" do
      other_developer = create(:developer)
      division = create(:division, developer: other_developer)
      model_instance.send("#{belongs_to_association}=", division)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I can CRUD a model when associated with a development that is under my developer" do
      developer = current_user.permission_level
      development = create(:development, developer: developer)
      model_instance.send("#{belongs_to_association}=", development)

      all_actions.each do |action|
        expect(subject).to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with another developers development" do
      other_developer = create(:developer)
      development = create(:development, developer: other_developer)
      model_instance.send("#{belongs_to_association}=", development)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I can CRUD a model when associated with a division development that is under my developer" do
      developer = current_user.permission_level
      division = create(:division, developer: developer)
      division_development = create(:division_development, division: division)
      model_instance.send("#{belongs_to_association}=", division_development)

      all_actions.each do |action|
        expect(subject).to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with another developers division development" do
      other_developer = create(:developer)
      division = create(:division, developer: other_developer)
      division_development = create(:division_development, division: division)
      model_instance.send("#{belongs_to_association}=", division_development)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end
  end

  context "as a Division Admin" do
    let(:current_user) { create(:division_admin) }
    let(:model_instance) { polymorphic_class.new }

    specify "I can READ a model when associated with my divisions developer" do
      developer = current_user.permission_level.developer
      model_instance.send("#{belongs_to_association}=", developer)

      safe_actions.each do |action|
        expect(subject).to be_able_to(action, model_instance)
      end
    end

    specify "I cannot change a model when associated with my divisions developer" do
      developer = current_user.permission_level.developer
      model_instance.send("#{belongs_to_association}=", developer)

      unsafe_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with another developer" do
      other_developer = create(:developer)
      model_instance.send("#{belongs_to_association}=", other_developer)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I can CRUD a model when associated with my division" do
      division = current_user.permission_level
      model_instance.send("#{belongs_to_association}=", division)

      all_actions.each do |action|
        expect(subject).to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with another division" do
      other_division = create(:division)
      model_instance.send("#{belongs_to_association}=", other_division)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I can CRUD a model when associated with a development that is under my division" do
      division = current_user.permission_level
      division_development = create(:division_development, division: division)
      model_instance.send("#{belongs_to_association}=", division_development)

      all_actions.each do |action|
        expect(subject).to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with a development that is under my developer but not under my division" do
      developer = current_user.permission_level.developer
      development = create(:development, developer: developer)
      model_instance.send("#{belongs_to_association}=", development)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with another divisions development" do
      other_division = create(:division)
      division_development = create(:division_development, division: other_division)
      model_instance.send("#{belongs_to_association}=", division_development)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end
  end

  context "as a Development Admin" do
    let(:current_user) { create(:development_admin) }
    let(:model_instance) { polymorphic_class.new }

    specify "I can READ a model when associated with my developments developer" do
      developer = current_user.permission_level.developer
      model_instance.send("#{belongs_to_association}=", developer)

      safe_actions.each do |action|
        expect(subject).to be_able_to(action, model_instance)
      end
    end

    specify "I cannot change a model when associated with my developments developer" do
      developer = current_user.permission_level.developer
      model_instance.send("#{belongs_to_association}=", developer)

      unsafe_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with another developer" do
      other_developer = create(:developer)
      model_instance.send("#{belongs_to_association}=", other_developer)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with a division that is under my developments developer" do
      developer = current_user.permission_level.developer
      division = create(:division, developer: developer)
      model_instance.send("#{belongs_to_association}=", division)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with another developers division" do
      other_developer = create(:developer)
      division = create(:division, developer: other_developer)
      model_instance.send("#{belongs_to_association}=", division)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with another development that is under my developer" do
      developer = current_user.permission_level.developer
      development = create(:development, developer: developer)
      model_instance.send("#{belongs_to_association}=", development)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with another developers development" do
      other_developer = create(:developer)
      development = create(:development, developer: other_developer)
      model_instance.send("#{belongs_to_association}=", development)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with a division development that is under my developer" do
      developer = current_user.permission_level.developer
      division = create(:division, developer: developer)
      division_development = create(:division_development, division: division)
      model_instance.send("#{belongs_to_association}=", division_development)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with another developers division development" do
      other_developer = create(:developer)
      division = create(:division, developer: other_developer)
      division_development = create(:division_development, division: division)
      model_instance.send("#{belongs_to_association}=", division_development)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end
  end

  context "as a Division Development Admin" do
    let(:developer) { create(:developer) }
    let(:division) { create(:division, developer: developer) }
    let(:division_development) { create(:division_development, division: division) }
    let(:current_user) { create(:development_admin, permission_level: division_development) }
    let(:model_instance) { polymorphic_class.new }

    specify "I can READ a model when associated with my developments developer" do
      model_instance.send("#{belongs_to_association}=", developer)

      safe_actions.each do |action|
        expect(subject).to be_able_to(action, model_instance)
      end
    end

    specify "I cannot change a model when associated with my developments developer" do
      model_instance.send("#{belongs_to_association}=", developer)

      unsafe_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with another developer" do
      other_developer = create(:developer)
      model_instance.send("#{belongs_to_association}=", other_developer)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I can READ a model when associated with the division that my development is under" do
      model_instance.send("#{belongs_to_association}=", division)

      safe_actions.each do |action|
        expect(subject).to be_able_to(action, model_instance)
      end
    end

    specify "I cannot change a model when associated with the division that my development is under" do
      model_instance.send("#{belongs_to_association}=", division)

      unsafe_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with another division that is under my developments developer" do
      developer = current_user.permission_level.developer
      division = create(:division, developer: developer)
      model_instance.send("#{belongs_to_association}=", division)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with another developers division" do
      other_developer = create(:developer)
      division = create(:division, developer: other_developer)
      model_instance.send("#{belongs_to_association}=", division)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with another development that is under my developer" do
      development = create(:development, developer: developer)
      model_instance.send("#{belongs_to_association}=", development)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with another developers development" do
      other_developer = create(:developer)
      development = create(:development, developer: other_developer)
      model_instance.send("#{belongs_to_association}=", development)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I can CRUD a model when associated with my division development" do
      model_instance.send("#{belongs_to_association}=", division_development)

      all_actions.each do |action|
        expect(subject).to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with a division development that is under my developer" do
      division_development = create(:division_development, division: division)
      model_instance.send("#{belongs_to_association}=", division_development)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with another developers division development" do
      other_developer = create(:developer)
      division = create(:division, developer: other_developer)
      division_development = create(:division_development, division: division)
      model_instance.send("#{belongs_to_association}=", division_development)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end
  end

  context "as a Site Admin" do
    let(:developer) { create(:developer) }
    let(:development) { create(:development, developer: developer) }
    let(:current_user) { create(:site_admin, permission_level: development) }
    let(:model_instance) { polymorphic_class.new }

    specify "I can READ a model when associated with my developments developer" do
      model_instance.send("#{belongs_to_association}=", developer)

      safe_actions.each do |action|
        expect(subject).to be_able_to(action, model_instance)
      end
    end

    specify "I cannot change a model when associated with my developments developer" do
      developer = current_user.permission_level.developer
      model_instance.send("#{belongs_to_association}=", developer)

      unsafe_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with another developer" do
      other_developer = create(:developer)
      model_instance.send("#{belongs_to_association}=", other_developer)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with a division that is under my developments developer" do
      developer = current_user.permission_level.developer
      division = create(:division, developer: developer)
      model_instance.send("#{belongs_to_association}=", division)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with another developers division" do
      other_developer = create(:developer)
      division = create(:division, developer: other_developer)
      model_instance.send("#{belongs_to_association}=", division)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with another development that is under my developer" do
      developer = current_user.permission_level.developer
      development = create(:development, developer: developer)
      model_instance.send("#{belongs_to_association}=", development)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with another developers development" do
      other_developer = create(:developer)
      development = create(:development, developer: other_developer)
      model_instance.send("#{belongs_to_association}=", development)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with a division development that is under my developer" do
      developer = current_user.permission_level.developer
      division = create(:division, developer: developer)
      division_development = create(:division_development, division: division)
      model_instance.send("#{belongs_to_association}=", division_development)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end

    specify "I cannot CRUD a model when associated with another developers division development" do
      other_developer = create(:developer)
      division = create(:division, developer: other_developer)
      division_development = create(:division_development, division: division)
      model_instance.send("#{belongs_to_association}=", division_development)

      all_actions.each do |action|
        expect(subject).not_to be_able_to(action, model_instance)
      end
    end
  end

end
