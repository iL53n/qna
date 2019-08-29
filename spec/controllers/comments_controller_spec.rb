require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:comment) { create(:comment, commentable: question, user: user) }
  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new users comment in the database' do
        expect { post :create, params: {comment: attributes_for(:comment), question_id: question }, format: :js }.to change(user.comments, :count).by(1)
      end

      it 'saves a new questions comment in the database' do
        expect { post :create, params: {comment: attributes_for(:comment), question_id: question }, format: :js }.to change(question.comments, :count).by(1)
      end

      it 'render create template' do
        post :create, params: {comment: attributes_for(:comment), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:comment_invalid) { attributes_for(:comment, :invalid) }

      it 'does not save the answer' do
        expect { post :create, params: {comment: comment_invalid, question_id: question }, format: :js }.to_not change(user.comments, :count)
      end
      it 'redirect to current view' do
        post :create, params: {comment: comment_invalid, question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end
  end
end

