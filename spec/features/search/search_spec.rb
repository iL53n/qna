require 'sphinx_helper'

feature 'User can search globally or in resources', %q{
    In order to fast find info
    As a guest
    I'd like to be able to search globally or in resources
} do

  given!(:questions) { create_list(:question, 3) }
  given!(:question) { questions.first }

  describe 'Searching', js: true, sphinx: true do
    before { visit root_path }

    scenario 'question' do
      ThinkingSphinx::Test.run do
        within '.search_form' do
          fill_in 'q', with: question.title
          click_on 'Search'
        end

        within '.search_result' do
          expect(page).to have_content question.title

          questions.drop(1).each do |q|
            expect(page).to_not have_content q.title
          end
        end
      end
    end

    scenario 'empty query' do
      ThinkingSphinx::Test.run do
        within '.search_form' do
          click_on 'Search'
        end

        expect(page).to have_content 'Search field is empty'

        questions.each do |q|
          expect(page).to_not have_content q.title
        end
      end
    end
  end
end