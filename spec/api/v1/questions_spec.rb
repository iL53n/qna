require 'rails_helper'

describe 'Questions API', type: :request do
  let(:me) { create(:user) }
  let!(:question) { create(:question, :add_file, user: me) }
  let(:question_response) { json['question'] }
  let(:headers) { { "ACCEPT" => "application/json" } }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request successful'

      it_behaves_like 'Return list' do
        let(:resource_response) { json['questions'] }
        let(:resource) { questions }
      end

      it_behaves_like 'Public fields' do
        let(:attrs) { %w[id title body created_at updated_at] }
        let(:resource_response) { question_response }
        let(:resource) { question }
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it_behaves_like 'Return list' do
          let(:resource_response) { question_response['answers'] }
          let(:resource) { answers }
        end

        it_behaves_like 'Public fields' do
          let(:attrs) { %w[id body created_at updated_at] }
          let(:resource_response) { answer_response }
          let(:resource) { answer }
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:answers) { create_list(:answer, 3, question: question) }
      let!(:links) { create_list(:link, 3, linkable: question) }
      let!(:comments) { create_list(:comment, 3, commentable: question) }
      let!(:files) { question.files }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it_behaves_like 'Return list' do
          let(:resource_response) { question_response['answers'] }
          let(:resource) { answers }
        end

        it_behaves_like 'Public fields' do
          let(:attrs) { %w[id body user_id created_at updated_at] }
          let(:resource_response) { answer_response }
          let(:resource) { answer }
        end
      end

      describe 'links' do
        let(:link) { links.last }
        let(:link_response) { question_response['links'].first }

        it_behaves_like 'Return list' do
          let(:resource_response) { question_response['links'] }
          let(:resource) { links }
        end

        it_behaves_like 'Public fields' do
          let(:attrs) { %w[id name url] }
          let(:resource_response) { link_response }
          let(:resource) { link }
        end
      end

      describe 'comments' do
        let(:comment) { comments.last }
        let(:comment_response) { question_response['comments'].first }

        it_behaves_like 'Return list' do
          let(:resource_response) { question_response['comments'] }
          let(:resource) { comments }
        end

        it_behaves_like 'Public fields' do
          let(:attrs) { %w[id body] }
          let(:resource_response) { comment_response }
          let(:resource) { comment }
        end
      end

      describe 'files' do
        it_behaves_like 'Return list' do
          let(:resource_response) { question_response['files'] }
          let(:resource) { files }
        end

        it 'returns url fields for question files' do
          expect(question_response['files'].first['url']).to eq rails_blob_path(files.first, only_path: true)
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions/' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      describe 'create with valid attributes' do
        let(:params) { { access_token: access_token.token,
                         question: { title: question.title, body: question.body } } }

        before { post api_path, headers: headers, params: params }

        it_behaves_like 'Request successful'

        it 'saves a new question in the database' do
          expect(Question.count).to eq 2
        end

        it_behaves_like 'Public fields' do
          let(:attrs) { %w[title body] }
          let(:resource_response) { question_response }
          let(:resource) { question }
        end
      end

      describe 'try create with invalid attributes' do
        let(:params) { { access_token: access_token.token,
                         question: { title: nil, body: nil } } }

        before { post api_path, headers: headers, params: params }

        it_behaves_like 'Request_unprocessable_entity'

        it 'does not save a new question in the database' do
          expect(Question.count).to eq 1
        end

        it_behaves_like 'Errors'
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      describe 'update with valid attributes' do
        let(:params) { { access_token: access_token.token,
                         question: { title: question.title, body: question.body } } }

        before { patch api_path, headers: headers, params: params }

        it_behaves_like 'Request successful'

    #     it 'update question in the database, but not create new' do
    #       expect(Question.count).to eq 1
    #     end
    #
    #     it_behaves_like 'Public fields' do
    #       let(:attrs) { %w[title body] }
    #       let(:resource_response) { question_response }
    #       let(:resource) { question }
    #     end
    #   end
    #
    #   describe 'try update with invalid attributes' do
    #     let(:params) { { access_token: access_token.token,
    #                      question: { title: nil, body: nil } } }
    #
    #     before { patch api_path, headers: headers, params: params }
    #
    #     it_behaves_like 'Request_unprocessable_entity'
    #
    #     it 'does not save a new question in the database' do
    #       expect(Question.count).to eq 1
    #     end
    #
    #     it_behaves_like 'Errors'
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      describe 'delete the question' do
        let(:params) { { access_token: access_token.token,
                         question_id: question.id } }

        before { delete api_path, headers: headers, params: params }

        it_behaves_like 'Request successful'

        it 'delete the question from the database' do
          expect(Question.count).to eq 0
        end

        it 'return empty' do
          expect(json).to eq({})
        end
      end
    end
  end
end