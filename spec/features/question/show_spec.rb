require 'rails_helper'

feature 'User can see question and answers to him', %q{
    In order to find the necessary information
    As a user
    I'd like to able to see the question and answers to him
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, :add_file, user: user) }
  given!(:answer) { create(:answer, :add_file, question: question, user: user) }
  given!(:link_q) { create(:link, linkable: question, name: 'Questions_link') }
  given!(:link_a) { create(:link, linkable: answer, name: 'Answers_link') }
  given!(:gist_link_q) { create(:link, :gist, linkable: question, name: 'Questions_gist_link') }


  background { visit question_path(question) }

  scenario 'User can see question and answers to him' do
    expect(page).to have_content question.title
    expect(page).to have_content question.body

    question.answers.each { |answer| expect(page).to have_content answer.body }
  end

  scenario 'User can see links' do
    expect(page).to have_content 'Questions_link'
    expect(page).to have_content 'Answers_link'
    expect(page).to have_content 'Hello, World!'
  end

  describe "Authenticated user", js: true do
    scenario "can votes" do
      sign_in(user)
      visit question_path(question)

      within ".question .question_votes" do
        click_link 'Up'
        expect(page).to_not have_content '1'
      end
    end

    scenario "can't votes for him question" do
      sign_in(create(:user))
      visit question_path(question)

      within ".question .question_votes" do
        click_link 'Up'
        expect(page).to_not have_content '1'
      end
    end
  end

  describe "Unauthenticated user can't delete" do
    scenario "question's file" do
      within ".question_files .file_#{question.files.first.id}" do
        expect(page).to_not have_link 'Delete file'
      end
    end

    scenario "answer's file" do
      within ".answer_files .file_#{answer.files.first.id}" do
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
      within ".question_files .file_#{question.files.first.id}" do
        page.accept_confirm do
          click_link 'Delete file'
        end

        expect(page).to_not have_content question.files
      end
    end

    scenario "answer's file" do
      within ".answer_files .file_#{answer.files.first.id}" do
        page.accept_confirm do
          click_link 'Delete file'
        end
        expect(page).to_not have_content answer.files
      end
    end

    scenario "question's link" do
      within ".question_links .link_#{link_q.id}" do
        page.accept_confirm do
          click_link 'Delete link'
        end
      end
      expect(page).to_not have_content link_q.name
    end

    scenario "answer's link" do
      within ".answer_links .link_#{link_a.id}" do
        page.accept_confirm do
          click_link 'Delete link'
        end
      end
      expect(page).to_not have_content link_a.name
    end
  end

  describe "Not author can't delete" do
    background do
      sign_in(create(:user))

      visit question_path(question)
    end

    scenario "question's file" do
      within ".question_files .file_#{question.files.first.id}" do
        expect(page).to_not have_link 'Delete file'
      end
    end

    scenario "answer's file" do
      within ".answer_files .file_#{answer.files.first.id}" do
        expect(page).to_not have_link 'Delete file'
      end
    end

    scenario "question's link" do
      within ".question_links .link_#{link_q.id}" do
        expect(page).to_not have_link 'Delete link'
      end
    end

    scenario "answer's link" do
      within ".answer_links .link_#{link_a.id}" do
        expect(page).to_not have_link 'Delete link'
      end
    end
  end
end
