require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new question answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'saves a new user answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(user.answers, :count).by(1)
      end

      it 'redirect to current question view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:answer_invalid) { attributes_for(:answer, :invalid) }

      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: answer_invalid }, format: :js }.to_not change(question.answers, :count)
      end
      it 'redirect to current question view' do
        post :create, params: { question_id: question, answer: answer_invalid }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'POST #up' do
    before { login(create(:user)) }
    it 'saves a new vote in the database' do
      expect { post :up, params: { id: answer.id, format: :json } }.to change(answer.votes, :count).by(1)
    end
  end

  describe 'POST #cancel' do
    before do
      post :up, params: { id: answer.id, format: :json }
      login(create(:user))
    end

    it 'deletes a vote in the database' do
      expect { post :cancel, params: { id: answer.id, format: :json } }.to change(answer.votes, :count).by(-1)
    end
  end

  describe 'POST #down' do
    before { login(create(:user)) }
    it 'saves a new vote in the database' do
      expect { post :down, params: { id: answer.id, format: :json } }.to change(answer.votes, :count).by(1)
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, user: user, question: question) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update template' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update template' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'User tries to edit not his answer' do
      before { login(create(:user)) }

      it 'not edits the answer' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end

      it 'renders update template' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:authored_answer) { create(:answer, user: user, question: question) }

    context 'User tries to delete his answer' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: authored_answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: authored_answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'User tries to delete not his answer' do
      before { login(create(:user)) }

      it 'not deletes the answer' do
        expect { delete :destroy, params: { id: authored_answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: authored_answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #best' do
    let!(:answer) { create(:answer, user: user, question: question) }

    context 'User set best answer to his question' do
      before { login(user) }

      it 'choice the best answer' do
        patch :best, params: { id: answer }, format: :js
        answer.reload
        expect(answer).to be_best
      end
    end

    context 'User set best answer to not his question' do
      before { login(create(:user)) }

      it 'does not choice the best answer' do
        patch :best, params: { id: answer }, format: :js
        answer.reload
        expect(answer).to_not be_best
      end
    end
  end
end

