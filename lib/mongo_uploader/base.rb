module MongoUploader

  class Base

    attr_accessor :host, :db, :user, :password, :url_prefix, :relative_url_root

    def initialize
      @host       = 'localhost'
      @db         = 'app'
      @url_prefix = 'mongo'
      @user       = nil
      @password   = nil
      @relative_url_root = ""
    end

    class << self

      def config
        @instance ||= new
      end

      def configure(&block)
        class_eval(&block)
      end

      protected

      def method_missing(*args, &block)
        config.send(*args, &block)
      end

    end

  end

end
