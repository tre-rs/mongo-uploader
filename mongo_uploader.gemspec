# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mongo_uploader/version"

Gem::Specification.new do |s|
  s.name        = "mongo_uploader"
  s.version     = MongoUploader::VERSION
  s.authors     = ["Sandro Duarte"]
  s.email       = ["sandrods@gmail.com"]
  s.homepage    = "https://github.com/sandrods/mongo-uploader"
  s.summary     = %q{simple attachment handler to ActiveRecord wich stores files in MongoDB}
  s.description = %q{simple attachment handler to ActiveRecord wich stores files in MongoDB}

  s.rubyforge_project = "mongo_uploader"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "mongo", "1.12.5"
  s.add_runtime_dependency "bson", "1.12.5"
  s.add_runtime_dependency "bson_ext", "1.12.5"
  s.add_runtime_dependency "actionpack"

  s.add_runtime_dependency "mime-types", ">= 1.17"
  s.add_runtime_dependency "stringex", "~> 1.3.0"
end
