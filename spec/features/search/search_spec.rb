require 'sphinx_helper'

feature 'User can search globally or in resources', %q{
    In order to fast find info
    As a guest
    I'd like to be able to search globally or in resources
} do

  describe 'Searching', js: true, sphinx: true do
    before { visit root_path }

    given!(:questions) { create_list(:question, 3) }
    given!(:question) { questions.first }
    given!(:answers) { create_list(:answer, 3) }
    given!(:answer) { answers.first }
    given!(:comments) { create_list(:comment, 3, commentable: question) }
    given!(:comment) { comments.first }
    given!(:users) { create_list(:user, 3) }
    given!(:user) { users.first }

    # Services::Search::RESOURCE.each do |resource|
    #   context  'Question' do
    #     scenario "looking for in #{resource}" do
    #       ThinkingSphinx::Test.run do
    #         within '.search_form' do
    #           fill_in 'q', with: question.title
    #           select "#{resource}", from: 'resource'
    #           click_on 'Search'
    #         end
    #
    #         within '.search_result' do
    #           if resource == 'All' || resource == 'Question'
    #             expect(page).to have_content question.title
    #
    #             questions.drop(1).each do |q|
    #               expect(page).to_not have_content q.title
    #             end
    #           else
    #             questions.each do |q|
    #               expect(page).to_not have_content q.title
    #             end
    #           end
    #         end
    #       end
    #     end
    #   end
    # end

    it_behaves_like 'Search' do
      let(:objects) { questions }
      let(:object) { question }
      let(:context) { 'Question' }
      let(:attr) { 'title' }
    end

    # Services::Search::RESOURCE.each do |resource|
    #   context  'Answer' do
    #     scenario "looking for in #{resource}" do
    #       ThinkingSphinx::Test.run do
    #         within '.search_form' do
    #           fill_in 'q', with: answer.body
    #           select "#{resource}", from: 'resource'
    #           click_on 'Search'
    #         end
    #
    #         within '.search_result' do
    #           if resource == 'All' || resource == 'Answer'
    #             expect(page).to have_content answer.body
    #
    #             answers.drop(1).each do |q|
    #               expect(page).to_not have_content q.body
    #             end
    #           else
    #             answers.each do |q|
    #               expect(page).to_not have_content q.body
    #             end
    #           end
    #         end
    #       end
    #     end
    #   end
    # end
    #
    # Services::Search::RESOURCE.each do |resource|
    #   context  'Comment' do
    #     scenario "looking for in #{resource}" do
    #       ThinkingSphinx::Test.run do
    #         within '.search_form' do
    #           fill_in 'q', with: comment.body
    #           select "#{resource}", from: 'resource'
    #           click_on 'Search'
    #         end
    #
    #         within '.search_result' do
    #           if resource == 'All' || resource == 'Comment'
    #             expect(page).to have_content comment.body
    #
    #             comments.drop(1).each do |q|
    #               expect(page).to_not have_content q.body
    #             end
    #           else
    #             comments.each do |q|
    #               expect(page).to_not have_content q.body
    #             end
    #           end
    #         end
    #       end
    #     end
    #   end
    # end
    #
    # Services::Search::RESOURCE.each do |resource|
    #   context  'User' do
    #     scenario "looking for in #{resource}" do
    #       ThinkingSphinx::Test.run do
    #         within '.search_form' do
    #           fill_in 'q', with: user.email
    #           select "#{resource}", from: 'resource'
    #           click_on 'Search'
    #         end
    #
    #         within '.search_result' do
    #           if resource == 'All' || resource == 'User'
    #             expect(page).to have_content user.email
    #
    #             users.drop(1).each do |q|
    #               expect(page).to_not have_content q.email
    #             end
    #           else
    #             users.each do |q|
    #               expect(page).to_not have_content q.email
    #             end
    #           end
    #         end
    #       end
    #     end
    #   end
    # end
    #
    # scenario 'empty query' do
    #   ThinkingSphinx::Test.run do
    #     within '.search_form' do
    #       click_on 'Search'
    #     end
    #
    #     expect(page).to have_content 'Search field is empty'
    #
    #     questions.each do |q|
    #       expect(page).to_not have_content q.title
    #     end
    #   end
    # end
  end
end