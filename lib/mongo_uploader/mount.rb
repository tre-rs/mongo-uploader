# encoding: UTF-8

module MongoUploader

  module Mount

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def mongo_attachment(column, opts = {})

        after_destroy "delete_#{column.to_s}".to_sym

        define_method("#{column.to_s}_id") do
          with_value(column) { |val| val.split("/").first rescue val }
        end

        define_method("#{column.to_s}=") do |_file|
          obj_id = self.class.mongo_storage.store(_file)
          write_attribute(column.to_sym, "#{obj_id}/#{_file.original_filename.sanitize}")
        end

        define_method("set_#{column.to_s}") do |_file|
          obj_id = self.class.mongo_storage.store(_file)
          update_column(column.to_sym, "#{obj_id}/#{_file.original_filename.sanitize}")
        end

        define_method("#{column.to_s}") do
          return unless id = send("#{column.to_s}_id")
          self.class.mongo_storage.retrieve(id)
        end

        define_method("download_#{column.to_s}") do
          return unless id = send("#{column.to_s}_id")
          self.class.mongo_storage.retrieve(id).read.force_encoding("UTF-8")
        end

        define_method("delete_#{column.to_s}") do
          return unless id = send("#{column.to_s}_id")
          self.class.mongo_storage.delete(id)
        end

        define_method("remove_#{column.to_s}") do
          return unless id = send("#{column.to_s}_id")
          self.class.mongo_storage.delete(id)
          write_attribute(column.to_sym, nil)
        end

        define_method("#{column.to_s}_url") do
          with_value(column) { |val| "#{MongoUploader::Base.config.relative_url_root}/mongo/#{val}" }
        end

        define_method("#{column.to_s}_name") do
          with_value(column) { |val| val.split("/").last rescue val }
        end

        define_method("#{column.to_s}_present?") do
          read_attribute(column.to_sym).present?
        end

        define_method("#{column.to_s}_size") do
          return unless file = send("#{column.to_s}")
          Helper.new.number_to_human_size(file.file_length)
        end

        if opts[:db].present?
          @storage = MongoUploader::Storage.new(opts[:db])
        end

      end

      def mongo_storage
        @storage ||= MongoUploader::Storage.new()
      end

    end

    def with_value(column, &block)
      return unless value = read_attribute(column.to_sym)
      yield value
    end

  end

end
