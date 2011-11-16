Mongo Uploader
==============

simple attachment handler to ActiveRecord wich stores files in MongoDB 


Usage
-----

Generating the Initializer

    rails generate mongo_uploader:config

Options:

    MongoUploader::Base.configure do
    
      # MongoDB database
      config.db = "app"
      
      # MongoDB host
      config.host = "localhost"

      # if your MongoDB requires authentication
      #
      # config.user = "username"
      # config.password = "password"

      # prefix used by the middleware to redirect the requests to MongoDB
      #
      # config.url_prefix = "mongo"
    end

In your model:

    mongo_attachment :file

you should have a String column named `file` in your database.


Middleware
----------

The files will be served through a middleware directly from MongoDB.

You can use the `#{column}_url` method (`file_url` in the previous example) to get the url. This url will be something like:

    http://my_app.com/mongo/4ebd9286a17d735dbc000001/image_223.jpg



