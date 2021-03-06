require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  it_behaves_like 'voted' do
    before { login(user) }
    let(:voteable) { question }
  end

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end

    it 'assigns new answers for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns new link for question' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new Link to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'assigns a new Reward to @question' do
      expect(assigns(:question).reward).to be_a_new(Reward)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end

    it 'renders show edit' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new user question in the database' do
        expect { post :create, params: {question: attributes_for(:question) }, format: :js }.to change(user.questions, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: {question: attributes_for(:question) }
        expect(response).to redirect_to assigns :question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: {question: attributes_for(:question, :invalid) }, format: :js }.to_not change(Question, :count)
      end
      it 're-renders new view' do
        post :create, params: {question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq(question)
      end
      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new_title', body: 'new_body'} }, format: :js
        question.reload

        expect(question.title).to eq('new_title')
        expect(question.body).to eq('new_body')
      end

      it 'renders update template' do
        patch :update, params: { id: question, question: { title: 'new_title', body: 'new_body'} }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

      it 'does not change question' do
        question.reload

        expect(question.title).to_not eq(nil)
        expect(question.body).to_not eq('invalid_obj')
      end
      it 'renders update template' do
        expect(response).to render_template :update
      end
    end

    context 'User tries to edit not his question' do
      before { login(create(:user)) }

      it 'not edits the question' do
        patch :update, params: { id: question, question: { title: 'new_title', body: 'new_body'} }, format: :js
        question.reload
        expect(question.title).to_not eq 'new_title'
        expect(question.body).to_not eq 'new_body'
      end

      it 'renders update template' do
        patch :update, params: { id: question, question: { title: 'new_title', body: 'new_body'} }, format: :js
        expect(response).to have_http_status :forbidden
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    let!(:authored_question) { create(:question, user: user) }

    context 'User tries to delete his question' do
      it 'deletes the question' do
        expect { delete :destroy, params: { id: authored_question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'User tries to delete not his question' do
      before { login(create(:user)) }

      it 'not deletes the question' do
        expect { delete :destroy, params: { id: authored_question } }.to_not change(Question, :count)
      end

      it 'redirects to question view' do
        delete :destroy, params: { id: authored_question }, format: :js
        expect(response).to have_http_status :forbidden
      end
    end
  end
end
