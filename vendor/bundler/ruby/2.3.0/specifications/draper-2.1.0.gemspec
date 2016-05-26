# -*- encoding: utf-8 -*-
# stub: draper 2.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "draper"
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jeff Casimir", "Steve Klabnik"]
  s.date = "2015-03-27"
  s.description = "Draper adds an object-oriented layer of presentation logic to your Rails apps."
  s.email = ["jeff@casimircreative.com", "steve@steveklabnik.com"]
  s.homepage = "http://github.com/drapergem/draper"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "View Models for Rails"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0"])
      s.add_runtime_dependency(%q<actionpack>, [">= 3.0"])
      s.add_runtime_dependency(%q<request_store>, ["~> 1.0"])
      s.add_runtime_dependency(%q<activemodel>, [">= 3.0"])
      s.add_development_dependency(%q<ammeter>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0.9.2"])
      s.add_development_dependency(%q<rspec-rails>, ["~> 3.2"])
      s.add_development_dependency(%q<minitest-rails>, [">= 1.0"])
      s.add_development_dependency(%q<capybara>, [">= 0"])
      s.add_development_dependency(%q<active_model_serializers>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 3.0"])
      s.add_dependency(%q<actionpack>, [">= 3.0"])
      s.add_dependency(%q<request_store>, ["~> 1.0"])
      s.add_dependency(%q<activemodel>, [">= 3.0"])
      s.add_dependency(%q<ammeter>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0.9.2"])
      s.add_dependency(%q<rspec-rails>, ["~> 3.2"])
      s.add_dependency(%q<minitest-rails>, [">= 1.0"])
      s.add_dependency(%q<capybara>, [">= 0"])
      s.add_dependency(%q<active_model_serializers>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 3.0"])
    s.add_dependency(%q<actionpack>, [">= 3.0"])
    s.add_dependency(%q<request_store>, ["~> 1.0"])
    s.add_dependency(%q<activemodel>, [">= 3.0"])
    s.add_dependency(%q<ammeter>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0.9.2"])
    s.add_dependency(%q<rspec-rails>, ["~> 3.2"])
    s.add_dependency(%q<minitest-rails>, [">= 1.0"])
    s.add_dependency(%q<capybara>, [">= 0"])
    s.add_dependency(%q<active_model_serializers>, [">= 0"])
  end
end
