require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request successful'

      context 'user profile' do
        it_behaves_like 'Public fields' do
          let(:attrs) { %w[id email admin created_at updated_at] }
          let(:resource_response) { json }
          let(:resource) { me }
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

      it_behaves_like 'Request successful'

      it 'return all profiles but me' do
        expect(json.size).to eq(users.size - 1)
        expect(json).to_not include me
      end

      it_behaves_like 'Public fields' do
        let(:attrs) { %w[id email admin created_at updated_at] }
        let(:resource_response) { json.last }
        let(:resource) { users.last }
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json.last).to_not have_key(attr)
        end
      end
    end
  end
end