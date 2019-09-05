require 'sphinx_helper'

feature 'User can search globally or in resources', %q{
    In order to fast find info
    As a guest
    I'd like to be able to search globally or in resources
} do

  describe 'Searching', js: true, sphinx: true do

    before { visit root_path }

    context 'Question' do
      it_behaves_like 'Search' do
        let!(:objects) { create_list(:question, 3) }
        let(:object) { objects.first }
        let(:context) { 'Question' }
        let(:attr) { 'title' }
      end
    end

    context 'Answer' do
      it_behaves_like 'Search' do
        let!(:objects) { create_list(:answer, 3) }
        let(:object) { objects.first }
        let(:context) { 'Answer' }
        let(:attr) { 'body' }
      end
    end

    context 'Comment' do
      it_behaves_like 'Search' do
        let!(:objects) { create_list(:comment, 3,
                                    commentable: create(:question)) }
        let(:object) { objects.first }
        let(:context) { 'Comment' }
        let(:attr) { 'body' }
      end
    end

    context 'User' do
      it_behaves_like 'Search' do
        let!(:objects) { create_list(:user, 3) }
        let(:object) { objects.first }
        let(:context) { 'User' }
        let(:attr) { 'email' }
      end
    end
  end
end