# encoding: UTF-8

module MongoUploader

  class Storage

    def initialize()
      MongoUploader.logger.info "\nCONNECT: #{MongoUploader::Base.config.host}:#{MongoUploader::Base.config.db}"

      @db = Mongo::Connection.new(MongoUploader::Base.config.host).db(MongoUploader::Base.config.db)

      if MongoUploader::Base.config.user && MongoUploader::Base.config.password
        @db.authenticate(MongoUploader::Base.config.user, MongoUploader::Base.config.password)
      end

      @grid = Mongo::Grid.new(@db)
    end

    def store(_file)
      _filename = _file.original_filename.sanitize
      _content_type = ::MIME::Types.type_for(_file.original_filename).first.to_s

      MongoUploader.logger.debug "STORE: #{_filename} (#{_content_type})"

      @grid.put(_file, :content_type => _content_type, :filename => _filename)
    end

    def retrieve(_id)
      MongoUploader.logger.debug "RETRIEVE: #{_id}"

      id = BSON::ObjectId.from_string(_id)
      @grid.get(id)

    rescue Mongo::GridFileNotFound => e
      MongoUploader.logger.error e.message
    end

    def delete(_id)
      MongoUploader.logger.debug "DELETE: #{_id}"

      id = BSON::ObjectId.from_string(_id)
      @grid.delete(id)

    rescue Mongo::GridFileNotFound => e
      MongoUploader.logger.error e.message
    end

  end

end
