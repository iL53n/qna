require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/profiles/me' do
    it 'return 401 status if there is no access_token' do
      get '/api/v1/profiles/me', headers: headers
      expect(response.status).to eq 401
    end

    it 'return 401 status is acces_token is invalid' do
      get '/api/v1/profiles/me', params: { access_token: '1234' }, headers: headers
      expect(response.status).to eq 401
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end

      context 'user profile' do
        it 'returns all public fields' do
          %w[id email admin created_at updated_at].each do |attr|
            expect(json[attr]).to eq me.send(attr).as_json
          end
        end

        it 'does not return private fields' do
          %w[password encrypted_password].each do |attr|
            expect(json).to_not have_key(attr)
          end
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:users) { create_list(:user, 4) }
      let(:me) { users.first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end

      it 'return all profiles but me' do
        expect(json.size).to eq(users.size - 1)
        expect(json).to_not include me
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json.last[attr]).to eq users.last.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json.last).to_not have_key(attr)
        end
      end
    end
  end
end