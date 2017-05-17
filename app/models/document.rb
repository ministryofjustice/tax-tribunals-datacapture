class Document
  attr_reader :collection_ref, :full_name, :name, :last_modified
  alias_attribute :title, :name

  def initialize(attrs)
    @collection_ref = attrs.fetch(:collection_ref)
    @full_name = attrs[:name] || attrs.fetch(:title)
    @name = @full_name.split('/').last
    @last_modified = attrs[:last_modified]
  end

  def self.all_for_collection(collection_ref)
    for_collection(collection_ref, document_key: nil).group_by { |f| f.full_name.split('/').first.to_sym }.tap { |docs|
      Rails.logger.info(docs)
    }
  end

  def self.for_collection(collection_ref, document_key:)
    Uploader.list_files(
      collection_ref: collection_ref,
      document_key: document_key
    ).map {|file| new(file.merge(collection_ref: collection_ref)) }.sort
  end

  def encoded_name
    Base64.encode64(name)
  end

  # We use the encoded file name in the route path for DELETE (or fallback POST)
  # i.e. document_path(doc) due to it possibly having characters like dots, etc.
  #
  def to_param
    encoded_name
  end

  def <=>(other)
    last_modified <=> other.last_modified
  end

  def ==(other)
    other.collection_ref == collection_ref && other.full_name == full_name
  end
end
