require 'rails_helper'

feature 'User can see question and answers to him', %q{
    In order to find the necessary information
    As a user
    I'd like to able to see the question and answers to him
} do

  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  background { visit question_path(question) }

  scenario 'User can see question and answers to him' do
    expect(page).to have_content question.title
    expect(page).to have_content question.body

    question.answers.each { |answer| expect(page).to have_content answer.body }
  end
end