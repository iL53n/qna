require 'rails_helper'

describe 'Answers API', type: :request do
  let(:me) { create(:user) }
  let(:headers) { { "ACCEPT" => "application/json" } }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, :add_file, question: question, user: me) }
  let(:answer_response) { json['answer'] }

  describe 'GET /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:links) { create_list(:link, 3, linkable: answer) }
      let!(:comments) { create_list(:comment, 3, commentable: answer) }
      let!(:files) { answer.files }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      describe 'links' do
        let(:link) { links.last }
        let(:link_response) { answer_response['links'].first }

        it_behaves_like 'Return list' do
          let(:resource_response) { answer_response['links'] }
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
        let(:comment_response) { answer_response['comments'].first }

        it_behaves_like 'Return list' do
          let(:resource_response) { answer_response['comments'] }
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
          let(:resource_response) { answer_response['files'] }
          let(:resource) { files }
        end

        it 'returns url fields for question files' do
          expect(answer_response['files'].first['url']).to eq rails_blob_path(files.first, only_path: true)
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      describe 'create with valid attributes' do
        let(:params) { { access_token: access_token.token,
                         answer: { body: answer.body } } }

        before { post api_path, headers: headers, params: params }

        it_behaves_like 'Request successful'

        it 'saves a new question in the database' do
          expect(Answer.count).to eq 2
        end

        it_behaves_like 'Public fields' do
          let(:attrs) { %w[body] }
          let(:resource_response) { answer_response }
          let(:resource) { answer }
        end
      end

      describe 'try create with invalid attributes' do
        let(:params) { { access_token: access_token.token,
                         answer: { body: nil } } }

        before { post api_path, headers: headers, params: params }

        it_behaves_like 'Request_unprocessable_entity'

        it 'does not save a new answer in the database' do
          expect(Answer.count).to eq 1
        end

        it_behaves_like 'Errors'
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      describe 'update with valid attributes' do
        let(:params) { { access_token: access_token.token,
                         answer: { answer_body: answer.body } } }

        before { patch api_path, headers: headers, params: params }

        it_behaves_like 'Request successful'

        it 'update answer in the database, but not create new' do
          expect(Answer.count).to eq 1
        end

        it_behaves_like 'Public fields' do
          let(:attrs) { %w[body] }
          let(:resource_response) { answer_response }
          let(:resource) { answer }
        end
      end

      describe 'try update with invalid attributes' do
        let(:params) { { access_token: access_token.token,
                         answer: { body: nil } } }

        before { patch api_path, headers: headers, params: params }

        it_behaves_like 'Request_unprocessable_entity'

        it 'does not save a new answer in the database' do
          expect(Answer.count).to eq 1
        end

        it_behaves_like 'Errors'
      end

      describe 'DELETE /api/v1/answers/:id' do
        let(:api_path) { "/api/v1/answers/#{answer.id}" }

        it_behaves_like 'API Authorizable' do
          let(:method) { :delete }
        end

        context 'authorized' do
          describe 'delete the answer' do
            let(:params) { { access_token: access_token.token,
                             answer_id: answer.id } }

            before { delete api_path, headers: headers, params: params }

            it_behaves_like 'Request successful'

            it 'delete the answer from the database' do
              expect(Answer.count).to eq 0
            end

            it 'return empty' do
              expect(json).to eq({})
            end
          end
        end
      end
    end
  end
end