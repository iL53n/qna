class Link < ApplicationRecord
  GIST_URL = 'gist.github.com'.freeze

  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: URI::regexp(%w[http https])

  def gist_link?
    url_split[2] == GIST_URL
  end

  def gist_contents
    gist = client.gist(url_split.last)
    files = {}

    gist.files.each do |k, v|
      files[k] = v[:content]
    end

    files.values
  end

  private

  def client
    Octokit::Client.new(:access_token => Rails.application.credentials.dig(:gist_access_token))
  end

  def url_split
    url.split('/')
  end
end
