module MongoUploader

  class Railtie < Rails::Railtie

    initializer "mongo_uploader.use_middleware" do |app|
      app.middleware.use MongoUploader::Middleware
    end

  end

end