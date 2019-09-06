require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #result' do
    let(:questions) { create_list(:question, 3) }

    Services::Search::RESOURCE.each do |resource|
      context "#{resource}_with valid attributes" do
        before do
          allow(Services::Search).to receive(:call).and_return(questions)
          get :result, params: { q: questions.sample.title, resource: resource }
        end

        it 'return OK' do
          expect(response).to be_successful
        end

        it 'renders result template' do
          expect(response).to render_template :result
        end

        it "#{resource} assign Services::Search.call to @result" do
          expect(assigns(:result)).to eq questions
        end
      end

      context "#{resource}_with invalid attributes" do
        it 'show flash alert' do
          get :result, params: {q: '', resource: resource}
          expect(controller).to set_flash.now[:alert].to 'Search field is empty'
        end
      end
    end
  end
end
