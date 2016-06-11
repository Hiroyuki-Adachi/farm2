# -*- encoding: utf-8 -*-
# stub: composite_primary_keys 8.1.3 ruby lib

Gem::Specification.new do |s|
  s.name = "composite_primary_keys"
  s.version = "8.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Charlie Savage"]
  s.date = "2016-04-16"
  s.description = "Composite key support for ActiveRecord"
  s.homepage = "https://github.com/composite-primary-keys/composite_primary_keys"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.5.1"
  s.summary = "Composite key support for ActiveRecord"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, ["~> 4.2.0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<pg>, [">= 0"])
      s.add_development_dependency(%q<mysql2>, ["= 0.3.20"])
    else
      s.add_dependency(%q<activerecord>, ["~> 4.2.0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<pg>, [">= 0"])
      s.add_dependency(%q<mysql2>, ["= 0.3.20"])
    end
  else
    s.add_dependency(%q<activerecord>, ["~> 4.2.0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<pg>, [">= 0"])
    s.add_dependency(%q<mysql2>, ["= 0.3.20"])
  end
end
