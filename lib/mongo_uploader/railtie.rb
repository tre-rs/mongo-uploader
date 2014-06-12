module MongoUploader

  class Railtie < Rails::Railtie

    initializer 'Rails logger' do
      MongoUploader.logger = ::Logger.new(Rails.root.join('log/mongo_uploader.log'), 10, 1_048_576)

      MongoUploader.logger.formatter = proc do |severity, datetime, progname, msg|
        "[#{Process.pid}] #{datetime} - #{msg}\n"
      end

    end

    initializer "mongo_uploader.use_middleware" do |app|
      app.middleware.use MongoUploader::Middleware
    end

  end

end
