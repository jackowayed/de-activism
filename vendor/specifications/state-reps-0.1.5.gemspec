# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{state-reps}
  s.version = "0.1.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Daniel Jackoway"]
  s.autorequire = %q{name}
  s.date = %q{2009-05-20}
  s.email = %q{jackowayed@gmail.com}
  s.files = ["bin/reps-main.rb", "lib/person.rb", "lib/state-reps.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/jackowayed/state-reps/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Determines person's state senate and representative districts. Setup for Delaware, but may work on other states}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
