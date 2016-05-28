# -*- encoding: utf-8 -*-
# stub: era_ja 0.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "era_ja"
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["tomi"]
  s.date = "2016-02-07"
  s.description = "Convert to Japanese era."
  s.email = ["tomiacannondale@gmail.com"]
  s.homepage = "https://github.com/tomiacannondale/era_ja"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "Convert Date or Time instance to String of Japanese era."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, ["~> 10.1.0"])
      s.add_development_dependency(%q<rspec>, ["~> 3.1.0"])
      s.add_development_dependency(%q<guard-rspec>, ["~> 4.5.0"])
      s.add_development_dependency(%q<rb-fsevent>, ["~> 0.9.4"])
      s.add_development_dependency(%q<terminal-notifier-guard>, ["~> 1.6.4"])
      s.add_development_dependency(%q<yard>, ["~> 0.8.7"])
    else
      s.add_dependency(%q<rake>, ["~> 10.1.0"])
      s.add_dependency(%q<rspec>, ["~> 3.1.0"])
      s.add_dependency(%q<guard-rspec>, ["~> 4.5.0"])
      s.add_dependency(%q<rb-fsevent>, ["~> 0.9.4"])
      s.add_dependency(%q<terminal-notifier-guard>, ["~> 1.6.4"])
      s.add_dependency(%q<yard>, ["~> 0.8.7"])
    end
  else
    s.add_dependency(%q<rake>, ["~> 10.1.0"])
    s.add_dependency(%q<rspec>, ["~> 3.1.0"])
    s.add_dependency(%q<guard-rspec>, ["~> 4.5.0"])
    s.add_dependency(%q<rb-fsevent>, ["~> 0.9.4"])
    s.add_dependency(%q<terminal-notifier-guard>, ["~> 1.6.4"])
    s.add_dependency(%q<yard>, ["~> 0.8.7"])
  end
end
