# encoding: UTF-8

module MongoUploader

  module Mount

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def mongo_attachment(column)

        after_destroy "delete_#{column.to_s}".to_sym

        define_method("#{column.to_s}=") do |_file|
          obj_id = self.class.mongo_storage.store(_file)
          write_attribute(column.to_sym, "#{obj_id}/#{_file.original_filename}")
        end

        define_method("#{column.to_s}") do
          tmp = read_attribute(column.to_sym)
          id = tmp.split("/").first rescue tmp
          self.class.mongo_storage.retrieve(id)
        end

        define_method("#{column.to_s}_url") do
          id = read_attribute(column.to_sym)
          "/mongo/#{id}"
        end

        define_method("#{column.to_s}_name") do
          url = read_attribute(column.to_sym)
          url.split("/").last rescue url
        end

        define_method("#{column.to_s}_id") do
          url = read_attribute(column.to_sym)
          url.split("/").first rescue url
        end

        define_method("delete_#{column.to_s}") do
          id = send("#{column.to_s}_id")
          self.class.mongo_storage.delete(id)
        end

      end

      def mongo_storage
        @storage ||= MongoUploader::Storage.new()
      end

    end

  end

end