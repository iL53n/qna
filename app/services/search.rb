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
    if r_include?
      all? ? search(ThinkingSphinx) : search(@resource.constantize)
    end
  end

  private

  def r_include?
    RESOURCE.include?(@resource)
  end

  def all?
    @resource == 'All'
  end

  def search(resource)
    resource.search(@q_text)
  end
end