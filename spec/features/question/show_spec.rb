require 'rails_helper'

feature 'User can see question and answers to him', %q{
    In order to find the necessary information
    As a user
    I'd like to able to see the question and answers to him
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, :add_file, user: user) }
  given!(:answer) { create(:answer, :add_file, question: question, user: user) }

  background { visit question_path(question) }

  scenario 'User can see question and answers to him' do
    expect(page).to have_content question.title
    expect(page).to have_content question.body

    question.answers.each { |answer| expect(page).to have_content answer.body }
  end

  describe "Unauthenticated user can't delete" do
    scenario "question's file" do
      within ".question_files > .file_#{question.files.first.id}" do
        expect(page).to_not have_link 'Delete file'
      end
    end

    scenario "answer's file" do
      within ".answer_files > .file_#{answer.files.first.id}" do
        expect(page).to_not have_link 'Delete file'
      end
    end
  end

  describe 'Author can delete', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario "question's file" do
      within ".question_files > .file_#{question.files.first.id}" do
        page.accept_confirm do
          click_link 'Delete file'
        end

        expect(page).to_not have_content question.files
      end
    end

    scenario "answer's file" do
      within ".answer_files > .file_#{answer.files.first.id}" do
        page.accept_confirm do
          click_link 'Delete file'
        end
        expect(page).to_not have_content answer.files
      end
    end
  end

  describe "Not author can't delete" do
    background do
      sign_in(create(:user))

      visit question_path(question)
    end

    scenario "question's file" do
      within ".question_files > .file_#{question.files.first.id}" do
        expect(page).to_not have_link 'Delete file'
      end
    end

    scenario "answer's file" do
      within ".answer_files > .file_#{answer.files.first.id}" do
        expect(page).to_not have_link 'Delete file'
      end
    end
  end
end
