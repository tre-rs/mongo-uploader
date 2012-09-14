# encoding: UTF-8

module MongoUploader

  class Storage

    def initialize()
      @db = Mongo::Connection.new(MongoUploader::Base.config.host).db(MongoUploader::Base.config.db)

      if MongoUploader::Base.config.user && MongoUploader::Base.config.password
        @db.authenticate(MongoUploader::Base.config.user, MongoUploader::Base.config.password)
      end

      @grid = Mongo::Grid.new(@db)
    end

    def store(_file)
      _filename = _file.original_filename.sanitize
      _content_type = ::MIME::Types.type_for(_file.original_filename).first.to_s

      @grid.put(_file, :content_type => _content_type, :filename => _filename)
    end

    def retrieve(_id)
      id = BSON::ObjectId.from_string(_id)
      @grid.get(id)

    rescue Mongo::GridFileNotFound => e
      puts "MONGODB - #{e.message}"
    end

    def delete(_id)
      id = BSON::ObjectId.from_string(_id)
      @grid.delete(id)

    rescue Mongo::GridFileNotFound => e
      puts "MONGODB - #{e.message}"
    end

  end

end