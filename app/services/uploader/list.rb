# frozen_string_literal: true

module Uploader
  class List
    include Uploader::AzureBlobStorage
    include Uploader::Logging

    ACTION_NAME = 'List'

    attr_accessor :collection, :folder, :logger

    def self.call(*args)
      new(*args)
    end

    def initialize(collection_ref, folder:, logger: Uploader::DummyLogger.new)
      @collection = collection_ref
      @folder = folder
      @logger = logger
    end

    def files
      {
        collection: collection,
        folder: folder,
        files: map_files
      }.tap { |o| log_result(o) }
    rescue StandardError => e
      log_result(error: e.inspect, backtrace: e.backtrace)
      raise
    end

    def files?
      !blobs.empty?
    end

    private

    def map_files
      blobs.map do |o|
        {
          key: o.name,
          title: o.name.sub(prefix, ''),
          last_modified: o.properties[:last_modified]
        }
      end
    end

    def prefix
      "#{[collection, folder].compact.join('/')}/"
    end

    def container_name
      ENV.fetch('AZURE_STORAGE_CONTAINER_NAME')
    end

    def blobs
      @blobs ||= client.list_blobs(container_name, prefix: prefix)
    end
  end
end