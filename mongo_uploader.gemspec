# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mongo_uploader/version"

Gem::Specification.new do |s|
  s.name        = "mongo_uploader"
  s.version     = MongoUploader::VERSION
  s.authors     = ["Sandro Duarte"]
  s.email       = ["sandroduarte@tre-rs.gov.br"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "mongo_uploader"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "mongo"
  s.add_runtime_dependency "bson"
  s.add_runtime_dependency "bson_ext"

  s.add_runtime_dependency "mime-types", "~> 1.17"
  s.add_runtime_dependency "stringex", "~> 1.3.0"
end
