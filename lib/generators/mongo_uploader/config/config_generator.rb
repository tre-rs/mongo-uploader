class MongoUploader::ConfigGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  desc "Creates a MongoUploader initializer."

  def copy_initializer
    say_status("copying", "Initializer", :green)
    copy_file "initializer.rb", "config/initializers/mongo_uploader.rb"
  end

end
