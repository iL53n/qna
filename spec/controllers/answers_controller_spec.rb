require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let (:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    before { login(user) }
    let(:answer) { attributes_for(:answer) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: answer } }.to change(question.answers, :count).by(1)
      end
      it 'redirect to current question view' do
        post :create, params: { question_id: question, answer: answer }
        expect(response).to redirect_to assigns :question
      end
    end

    context 'with invalid attributes' do
      let(:answer_invalid) { attributes_for(:answer, :invalid) }

      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: answer_invalid } }.to_not change(question.answers, :count)
      end
      it 'redirect to current question view' do
        post :create, params: { question_id: question, answer: answer_invalid }
        expect(response).to render_template :show
      end
    end
  end
end
