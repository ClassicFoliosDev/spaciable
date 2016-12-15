# -*- encoding: utf-8 -*-
# stub: paranoia 2.2.0.pre ruby lib

Gem::Specification.new do |s|
  s.name = "paranoia".freeze
  s.version = "2.2.0.pre"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["radarlistener@gmail.com".freeze]
  s.date = "2016-12-14"
  s.description = "    Paranoia is a re-implementation of acts_as_paranoid for Rails 3, 4, and 5,\n    using much, much, much less code. You would use either plugin / gem if you\n    wished that when you called destroy on an Active Record object that it\n    didn't actually destroy it, but just \"hid\" the record. Paranoia does this\n    by setting a deleted_at field to the current time when you destroy a record,\n    and hides it by scoping all queries on your model to only include records\n    which do not have a deleted_at field.\n".freeze
  s.email = []
  s.files = [".gitignore".freeze, ".travis.yml".freeze, "CHANGELOG.md".freeze, "CONTRIBUTING.md".freeze, "Gemfile".freeze, "LICENSE".freeze, "README.md".freeze, "Rakefile".freeze, "lib/paranoia.rb".freeze, "lib/paranoia/rspec.rb".freeze, "lib/paranoia/version.rb".freeze, "paranoia.gemspec".freeze, "test/paranoia_test.rb".freeze]
  s.homepage = "http://rubygems.org/gems/paranoia".freeze
  s.required_ruby_version = Gem::Requirement.new(">= 2.0".freeze)
  s.rubygems_version = "2.6.4".freeze
  s.summary = "Paranoia is a re-implementation of acts_as_paranoid for Rails 3, 4, and 5, using much, much, much less code.".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>.freeze, ["< 5.1", ">= 4.0"])
      s.add_development_dependency(%q<bundler>.freeze, [">= 1.0.0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    else
      s.add_dependency(%q<activerecord>.freeze, ["< 5.1", ">= 4.0"])
      s.add_dependency(%q<bundler>.freeze, [">= 1.0.0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>.freeze, ["< 5.1", ">= 4.0"])
    s.add_dependency(%q<bundler>.freeze, [">= 1.0.0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end
