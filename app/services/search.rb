class Services::Search
  RESOURCE = %w[All Question Answer Comment User]

  def initialize(params)
    @resource = params[:resource]
    @q_text = ThinkingSphinx::Query.escape(params[:q])
  end

  def self.call(params)
    new(params).result
  end

  def result
    if RESOURCE.include?(@resource)
      @resource == 'All' ? search(ThinkingSphinx) : search(@resource.constantize)
    end
  end

  private

  def search(resource)
    resource.search(@q_text)
  end
end