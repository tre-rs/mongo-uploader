require 'mongo'
require 'timeout'
require 'mime/types'
require 'stringex'

require "mongo_uploader/extensions/string"

require "mongo_uploader/base"
require "mongo_uploader/helper"
require "mongo_uploader/version"
require "mongo_uploader/mount"
require "mongo_uploader/storage"
require "mongo_uploader/middleware"

require 'mongo_uploader/railtie' if defined?(Rails)

module MongoUploader
  mattr_accessor :logger
end

ActiveRecord::Base.send(:include, MongoUploader::Mount)
