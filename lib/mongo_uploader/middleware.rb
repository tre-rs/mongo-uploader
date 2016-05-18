require 'mongo'

module MongoUploader

  class GridFSConnectionError < StandardError ; end

  class Middleware

    attr_reader :hostname, :port, :database, :prefix, :db, :user, :password

    def initialize(app, options = {})
      options = {
        :hostname => Base.config.host,
        :database => Base.config.db,
        :prefix => Base.config.url_prefix,
        :port => Mongo::Connection::DEFAULT_PORT
      }.merge(options)

      @app = app
      @hostname = options[:hostname]
      @port = options[:port]
      @database = options[:database]
      @prefix = options[:prefix]
      @db = nil
      @user = options[:user]
      @password = options[:password]

      connect!
    end

    def call(env)
      request = Rack::Request.new(env)
      if request.path_info =~ /^\/#{prefix}\/(.+)$/
        gridfs_request($1)
      else
        @app.call(env)
      end
    end

    def gridfs_request(url)

      connect! unless @grid

      if @grid

        id = url.split("/").first
        oid = BSON::ObjectId.from_string(id)

        file = @grid.get(oid)

        [200, {'Content-Type' => file.content_type, 'Content-Length' => file.file_length.to_s}, [file.read]]

      else

        [500, {'Content-Type' => 'text/plain'}, ["MongoDB is down on #{@hostname}:#{@port}."]]

      end

    rescue Mongo::ConnectionFailure
      [500, {'Content-Type' => 'text/plain'}, ["MongoDB is down on #{@hostname}:#{@port}."]]

    rescue Mongo::GridError, BSON::InvalidObjectId
      [404, {'Content-Type' => 'text/plain'}, ["File not found: #{url}"]]

    end

    private

    def connect!
      Timeout::timeout(5) do
        @db = Mongo::Connection.new(hostname, @port).db(database)
        if @user and @password
          @db.authenticate(@user, @password)
        end
        @grid = Mongo::Grid.new(@db)
        @db
      end
    rescue Exception => e
      puts "MongoUploader::GridFSConnectionError " + "Unable to connect to the MongoDB server (#{e.to_s})"
    end

  end

end
