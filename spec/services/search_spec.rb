require 'rails_helper'

RSpec.describe Services::Search do
  it 'All resource_calls search' do
    expect(ThinkingSphinx).to receive(:search).with('q_text')
    Services::Search.call(q: 'q_text', resource: 'All')
  end

  Services::Search::RESOURCE.drop(1).each do |resource|
    it "#{resource} resource_calls search" do
      expect(resource.singularize.constantize).to receive(:search).with('q_text')
      Services::Search.call(q: 'q_text', resource: resource)
    end
  end
end