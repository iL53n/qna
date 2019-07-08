require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:linkable) }

  it { should allow_value('http://google.com').for(:url) }
  it { should_not allow_value('google.com').for(:url) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe '#gist_link?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:link) { create(:link, linkable: question) }
    let(:gist_link) { create(:link, :gist, linkable: question) }

    it 'return true if link == gist' do
      expect(gist_link.gist_link?).to eq true
    end

    it 'return false if link != gist' do
      expect(link.gist_link?).to eq false
    end

    it 'gist_contents should return array with content gist' do
      expect(gist_link.gist_contents).to eq ['Hello, World!']
    end
  end
end