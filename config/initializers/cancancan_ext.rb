module SkipIfManageAll
  def accessible_by(ability, action = :index)
    first_rule = ability.send(:rules)[0]
    manage_all = first_rule.subjects == [:all] && first_rule.actions == [:manage]

    manage_all ? self.all : super
  end
end

module CanCan
  module ModelAdditions
    module ClassMethods
      prepend SkipIfManageAll
    end
  end
end
ActiveRecord::Base.extend CanCan::ModelAdditions::ClassMethods
