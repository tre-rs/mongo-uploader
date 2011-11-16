# encoding: UTF-8

module MongoUploader

  class Storage

    def initialize()
      @db = Mongo::Connection.new(MongoUploader::Base.config.host).db(MongoUploader::Base.config.db)
      @grid = Mongo::Grid.new(@db)
    end

    def store(_file)
      _filename = sanitize(_file.original_filename)
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

    private

    def sanitize(name)
      return unless name

      name = name.to_ascii

      name = name.gsub(/[^a-zA-Z0-9\.\-\+_]/, "_")

      name = "_#{name}" if name =~ /\A\.+\z/
      name = "unnamed" if name.size == 0
      return name.mb_chars.to_s
    end

  end

end