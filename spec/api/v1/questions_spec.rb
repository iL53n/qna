require 'rails_helper'

describe 'Questions API', type: :request do
  let!(:question) { create(:question, :add_file) }
  let(:question_response) { json['question'] }
  let(:headers) { { "ACCEPT" => "application/json" } }
  let(:access_token) { create(:access_token) }

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

      it 'return 200 status' do
        expect(response).to be_successful
      end

      it 'return list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'return all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
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

        it 'return list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'return all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
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

        it 'return list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'return all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:link) { links.last }
        let(:link_response) { question_response['links'].first }

        it 'return list of links' do
          expect(question_response['links'].size).to eq 3
        end

        it 'return all public fields' do
          %w[id name url].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'comments' do
        let(:comment) { comments.last }
        let(:comment_response) { question_response['comments'].first }

        it 'return list of comments' do
          expect(question_response['comments'].size).to eq 3
        end

        it 'return all public fields' do
          %w[id body].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'files' do
        it 'return list of files' do
          expect(question_response['files'].size).to eq files.size
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

        it 'return status :created' do
          expect(response.status).to eq 201
        end

        it 'saves a new question in the database' do
          expect(Question.count).to eq 2
        end

        it 'return all public fields' do
          %w[title body].each do |attr|
            expect(question_response[attr]).to eq question.send(attr).as_json
          end
        end
      end

      describe 'try create with invalid attributes' do
        let(:params) { { access_token: access_token.token,
                         question: { title: nil, body: nil } } }

        before { post api_path, headers: headers, params: params }

        it 'return status :unprocessable_entity' do
          expect(response.status).to eq 422
        end

        it 'does not save a new question in the database' do
          expect(Question.count).to eq 1
        end

        it 'return error message' do
          expect(json['errors']).to be_truthy
        end
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

        it 'return status :created' do
          expect(response.status).to eq 201
        end

        it 'update question in the database, but not create new' do
          expect(Question.count).to eq 1
        end

        it 'return all public fields' do
          %w[title body].each do |attr|
            expect(question_response[attr]).to eq question.send(attr).as_json
          end
        end
      end

      describe 'try update with invalid attributes' do
        let(:params) { { access_token: access_token.token,
                         question: { title: nil, body: nil } } }

        before { patch api_path, headers: headers, params: params }

        it 'return status :unprocessable_entity' do
          expect(response.status).to eq 422
        end

        it 'does not save a new question in the database' do
          expect(Question.count).to eq 1
        end

        it 'return error message' do
          expect(json['errors']).to be_truthy
        end
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

        it 'return status :ok' do
          expect(response.status).to eq 200
        end

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