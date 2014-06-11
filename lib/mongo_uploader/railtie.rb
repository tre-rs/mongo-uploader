module MongoUploader

  class Railtie < Rails::Railtie

    initializer 'Rails logger' do
      MongoUploader.logger = Rails.logger
    end

    initializer "mongo_uploader.use_middleware" do |app|
      app.middleware.use MongoUploader::Middleware
    end

  end

end
