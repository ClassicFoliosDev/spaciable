module SkipIfManageAll
  def accessible_by(ability, action = :index)
    first_rule = ability.send(:rules)[0]

    if first_rule
      manage_all = first_rule.subjects == [:all] && first_rule.actions == [:manage]
      manage_all ? self.all : super
    else
      super
    end
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
