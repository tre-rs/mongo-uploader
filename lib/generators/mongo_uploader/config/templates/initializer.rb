MongoUploader::Base.configure do
  config.db = "app"
  config.host = "localhost"

  # if your dabasae requires authentication
  #
  # config.user = "username"
  # config.password = "password"

  # prefix used by the middleware to redirect the requests to MongoDb
  #
  # config.url_prefix = "mongo"
end