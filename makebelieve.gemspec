# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{makebelieve}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kristopher Kosmatka"]
  s.date = %q{2009-12-07}
  s.description = %q{
      A framework and tool set for building Bayesian Networks.  Included are
      a quasi domain specific language for network specification as well as
      several algorithms for performing inference queries and parameter
      learning.
    }
  s.email = %q{kjkosmatka@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/makebelieve.rb",
     "test/helper.rb",
     "test/test_makebelieve.rb"
  ]
  s.homepage = %q{http://github.com/kjkosmatka/makebelieve}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A toolbox for building Bayes Nets}
  s.test_files = [
    "test/helper.rb",
     "test/test_makebelieve.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

