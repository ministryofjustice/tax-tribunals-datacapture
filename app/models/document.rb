class Document
  attr_accessor :collection_ref, :name, :last_modified
  alias_attribute :title, :name

  def initialize(attrs)
    self.collection_ref = attrs.fetch(:collection_ref)
    self.name = attrs[:name] || attrs[:title]
    self.last_modified = attrs[:last_modified]
  end

  def self.for_collection(collection_ref, options = {})
    filtered_files = options.fetch(:filter, [])

    result = MojFileUploaderApiClient::ListFiles.new(collection_ref: collection_ref).call
    result.body.fetch(:files, []).
        reject { |file| filtered_files.include?(file[:title]) }.
        map { |file| new(file.merge(collection_ref: collection_ref)) }.compact
  end

  def to_param
    Base64.encode64(name)
  end
end
